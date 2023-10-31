# frozen_string_literal: true

class LearningResourcesController < ApplicationController
  def index
    @search_term = params[:search]
    @learning_resources = LearningResource.where('title LIKE ?', "%#{@search_term}%").order(created_at: :desc)
  end

  def new
    @learning_resources = current_user.learning_resources.build
  end

  def create
    @learning_resources = current_user.learning_resources.build(@learning_resource_params)
    if @learning_resources.save
      redirect_to learning_resources_path, notice: 'Learning material was added successfully.'
    else
      render :new
    end
  end

  private

  def learning_resource_params
    params.require(:learning_resorce).permit(:title, :description, :link, :expertise_level)
  end
end
