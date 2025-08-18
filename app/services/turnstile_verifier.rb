# frozen_string_literal: true

class TurnstileVerifier
  VERIFY_URI = URI('https://challenges.cloudflare.com/turnstile/v0/siteverify').freeze
  MAX_RETRIES = 3

  attr_reader :token, :ip

  def initialize(token, ip)
    @token = token
    @ip = ip
  end

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
