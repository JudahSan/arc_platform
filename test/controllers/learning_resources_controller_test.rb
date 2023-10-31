# frozen_string_literal: true

require 'test_helper'

class LRControllerTest < ActionDispatch::IntegrationTest
  setup do
    @learning_resource = learning_resources(:one) # Assuming you have fixtures set up
    @user = users(:one) # Assuming you have users fixtures set up
    sign_in @user
  end

  test 'should get index' do
    get learning_resources_url
    assert_response :success
  end

  test 'should get new' do
    get new_learning_resource_url
    assert_response :success
  end

  test 'should create learning resource' do
    assert_difference('LearningResource.count') do
      post learning_resources_url,
           params: { learning_resource: { title: 'Sample Title', description: 'Sample Description', link: 'https://example.com', expertise_level: 'Beginner' } }
    end

    assert_redirected_to learning_resources_url
  end
end
