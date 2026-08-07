# frozen_string_literal: true

class CompaniesController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
    @companies = Company.published.with_attached_logo

    @companies = @companies.where('name ILIKE ? OR description ILIKE ?', "%#{params[:query]}%", "%#{params[:query]}%") if params[:query].present?

    @companies = @companies.where(country: params[:country]) if params[:country].present?

    @countries = Company.published.distinct.pluck(:country).compact.sort
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)
    @company.published = false # Ensure it's not published by default

    if @company.save
      redirect_to built_with_ruby_path, notice: t('.success')
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def company_params
    params.expect(company: %i[name website_url careers_url country city description logo])
  end
end
