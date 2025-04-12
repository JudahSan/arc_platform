# frozen_string_literal: true

##
# Devise override Registration controller
module Users
  class RegistrationsController < Devise::RegistrationsController
    ##
    # Devise override Registration create action

    invisible_captcha only: [:create], honeypot: :nickname
    def create
      super do
        resource.users_chapters.create(chapter_id: params[:chapter_id], main_chapter: true) if resource.persisted?
      end
    end
  end
end
