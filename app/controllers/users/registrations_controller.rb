# frozen_string_literal: true

##
# Devise override Registration controller
module Users
  class RegistrationsController < Devise::RegistrationsController
    ##
    # Devise override Registration create action

    invisible_captcha only: [:create], honeypot: :nickname

    # Cloudflare Turnstile verification.
    # This before_action will ONLY run in production environment.
    # It will raise RailsCloudflareTurnstile::Forbidden on failure.
    before_action :validate_cloudflare_turnstile, only: [:create] if Rails.env.production?

    # This will catch the RailsCloudflareTurnstile::Forbidden exception
    # raised by `validate_cloudflare_turnstile` and redirect the user.
    rescue_from RailsCloudflareTurnstile::Forbidden, with: :forbidden_turnstile

    before_action :check_bot_detection, only: [:create]

    def create
      super do
        resource.users_chapters.create(chapter_id: params[:chapter_id], main_chapter: true) if resource.persisted?
      end
    end

    private

    def check_bot_detection
      # If JavaScript is disabled or bot detection indicates a bot, reject the submission
      if params[:js_enabled].blank? || params[:bot_detection] == 'true'
        flash[:alert] = "Sorry, we couldn't process your request."
        redirect_to new_user_registration_path
      end
    end

    def forbidden_turnstile
      flash[:error] = "We had a problem creating your account."
      redirect_to root_path
    end
  end
end
