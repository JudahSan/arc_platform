# frozen_string_literal: true

class LandingController < ApplicationController
  # People should not require authentication for following actions
  skip_before_action :authenticate_user!, only: %i[index about learn code_of_conduct]
  def index; end

  ##
  # About us page
  def about; end

  ##
  # Featured learning materials
  def learn; end

  ##
  # Code of Conduct page
  def code_of_conduct; end
end
