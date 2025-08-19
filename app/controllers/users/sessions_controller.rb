# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    # Turnstile protection
    # Verifies the Cloudflare Turnstile token before allowing user sign in.
    # Expects the front-end to provide the token param name 'cf-turnstile-response'.
    # See: app/views/shared/_cloudflare_turnstile.html.erb and
    #      app/javascript/controllers/turnstile_controller.js
    # invisible_captcha only: [:create], honeypot: :nickname
    before_action :verify_turnstile, only: :create

    def new
      self.resource = resource_class.new
      clean_up_passwords(resource)
      respond_with(resource, serialize_options(resource))
    end

    private

    # Returns early if server-side verification succeeds; otherwise prepares the
    # form with an error and re-renders the page.
    def verify_turnstile
      token = params['cf-turnstile-response']
      return if TurnstileVerifier.new(token, request.remote_ip).verify

      handle_failed_turnstile_verification
    end

    # Renders the sign in form with an error message.
    # The message is sourced from I18n at 'turnstile.errors.login_failed'.
    def handle_failed_turnstile_verification
      self.resource = resource_class.new(sign_in_params)
      clean_up_passwords(resource)
      flash.now[:alert] = I18n.t('turnstile.errors.login_failed')
      render :new, status: :unprocessable_entity
    end
  end
end
