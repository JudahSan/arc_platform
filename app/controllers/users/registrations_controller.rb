# frozen_string_literal: true

##
# Devise override Registration controller
# Adds Cloudflare Turnstile verification before creating an account.
# Expects the front-end to provide the token param name 'cf-turnstile-response'.
# See: app/views/shared/_cloudflare_turnstile.html.erb and
#      app/javascript/controllers/turnstile_controller.js
module Users
  class RegistrationsController < Devise::RegistrationsController
    ##
    # Devise override Registration create action
    # allow_unathenticated_access only: [:new, :create]
    before_action :verify_turnstile, only: [:create]

    def create
      super do
        resource.users_chapters.create(chapter_id: params[:chapter_id], main_chapter: true) if resource.persisted?
      end
    end

    private

    # Returns early if server-side verification succeeds; otherwise prepares the
    # form with an error and re-renders the page.
    def verify_turnstile
      token = params['cf-turnstile-response']
      return if TurnstileVerifier.new(token, request.remote_ip).verify

      handle_failed_turnstile_verification
    end

    # Renders the sign up form with an error message.
    # The message is sourced from I18n at 'turnstile.errors.registration_failed'.
    def handle_failed_turnstile_verification
      self.resource = resource_class.new(sign_in_params)
      clean_up_passwords(resource)
      flash.now[:alert] = I18n.t('turnstile.errors.registration_failed')
      render :new, status: :unprocessable_entity
    end
  end
end
