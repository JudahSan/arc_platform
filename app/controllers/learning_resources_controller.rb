# frozen_string_literal: true

class LearningResourcesController < ApplicationController
  before_action :authenticate_user!, except: [:index] # Ensure users are authenticated for new and create actions

  def index
    @search_term = params[:search]
    @learning_resources = LearningResource.where('title LIKE ?', "%#{@search_term}%").order(created_at: :desc)
  end

  def new
    @learning_resource = current_user.learning_resources.build # Use singular form for variable name
  end

  def create
    @learning_resource = current_user.learning_resources.build(learning_resource_params)
    if @learning_resource.save
      redirect_to learning_resources_path, notice: 'Learning material was added successfully.'
    else
      render :new
    end
  end

  private

  def learning_resource_params
    params.require(:learning_resource).permit(:title, :description, :link, :expertise_level)
  end
end
