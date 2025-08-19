# frozen_string_literal: true

# Service object to verify Cloudflare Turnstile tokens on the server-side.
#
# Usage:
#   token = params['cf-turnstile-response']
#   verifier = TurnstileVerifier.new(token, request.remote_ip)
#   if verifier.verify
#     # proceed
#   else
#     # handle failure
#   end
#
# Configuration:
# - Requires Rails credentials under: cloudflare_turnstile.secret_key
#   rails credentials:edit
#   cloudflare_turnstile:
#     secret_key: YOUR_SECRET_KEY
#     site_key: YOUR_PUBLIC_SITE_KEY
# - Performs up to MAX_RETRIES attempts with exponential backoff when network
#   errors occur. Returns boolean true/false and logs failures.
# - Endpoint: https://challenges.cloudflare.com/turnstile/v0/siteverify
#
class TurnstileVerifier
  VERIFY_URI = URI('https://challenges.cloudflare.com/turnstile/v0/siteverify').freeze
  MAX_RETRIES = 3

  attr_reader :token, :ip

  def initialize(token, ip)
    @token = token
    @ip = ip
  end

  # Returns true on successful verification, false otherwise.
  # Returns false immediately if token is blank.
  def verify
    return false if token.blank?

    attempt_verification
  end

  private

  def attempt_verification
    MAX_RETRIES.times do |attempt|
      return true if successful?(attempt)

      sleep(backoff_time(attempt)) if attempt < MAX_RETRIES - 1
    end
    false
  end

  def successful?(attempt)
    response = send_request

    if response['success'] == true
      true
    else
      Rails.logger.warn "Turnstile verification failed: #{response['error-codes'].inspect}"
      false
    end
  rescue StandardError => e
    Rails.logger.error "Turnstile verification error (attempt #{attempt + 1}/#{MAX_RETRIES}): #{e.message}"
    false
  end

  def backoff_time(attempt)
    2**attempt
  end

  def send_request
    response = Net::HTTP.post_form(
      VERIFY_URI,
      secret: secret_key,
      response: token,
      remoteip: ip
    )
    JSON.parse(response.body)
  end

  def secret_key
    Rails.application.credentials.dig(:cloudflare_turnstile, :secret_key).tap do |key|
      raise 'Turnstile secret key is not configured' if key.blank?
    end
  end
end
