# frozen_string_literal: true

require 'test_helper'

class CompaniesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @company = companies(:one)
    @user = users(:member) # Use a valid fixture name
  end

  test 'should get index without authentication' do
    get built_with_ruby_url
    assert_response :success
  end

  test 'should redirect new when not authenticated' do
    get new_company_url
    assert_redirected_to new_user_session_path
  end

  test 'should get new when authenticated' do
    sign_in @user
    get new_company_url
    assert_response :success
  end

  test 'should redirect create when not authenticated' do
    assert_no_difference('Company.count') do
      post companies_url, params: { company: { name: 'New Co', country: 'Kenya' } }
    end
    assert_redirected_to new_user_session_path
  end

  test 'should create company when authenticated' do
    sign_in @user
    assert_difference('Company.count') do
      post companies_url, params: { company: { name: 'New Co', country: 'Kenya' } }
    end
    assert_redirected_to built_with_ruby_path
  end
end
