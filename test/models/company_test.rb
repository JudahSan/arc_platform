# frozen_string_literal: true

require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
  test 'should be valid with required attributes' do
    company = Company.new(name: 'Test Company', country: 'Kenya')
    assert company.valid?
  end

  test 'should be invalid without name' do
    company = Company.new(country: 'Kenya')
    assert_not company.valid?
  end

  test 'should be invalid without country' do
    company = Company.new(name: 'Test Company')
    assert_not company.valid?
  end

  test 'should generate slug from name' do
    company = Company.create!(name: 'Test Company', country: 'Kenya')
    assert_equal 'test-company', company.slug
  end

  test 'should generate unique slug' do
    Company.create!(name: 'Test Company', country: 'Kenya')
    company2 = Company.create!(name: 'Test Company', country: 'Uganda')
    assert_equal 'test-company-1', company2.slug
  end

  test 'should have logo attachment' do
    company = Company.new(name: 'Test', country: 'Kenya')
    assert company.respond_to?(:logo)
  end
end
