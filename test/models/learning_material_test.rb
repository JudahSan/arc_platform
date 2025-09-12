# frozen_string_literal: true

# == Schema Information
#
# Table name: learning_materials
#
#  id         :bigint           not null, primary key
#  featured   :boolean
#  level      :integer
#  link       :string
#  thumbnail  :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_learning_materials_on_featured  (featured)
#  index_learning_materials_on_level     (level)
#  index_learning_materials_on_title     (title)
#
require 'test_helper'

class LearningMaterialTest < ActiveSupport::TestCase
  fixtures :learning_materials

  test 'valid fixture object' do
    assert learning_materials(:ruby_basics).valid?
    assert learning_materials(:rails_intermediate).valid?
    assert learning_materials(:rails_advanced).valid?
  end

  test 'requires title, level, link' do
    lm = LearningMaterial.new
    assert_not lm.valid?
    assert_includes lm.errors.attribute_names, :title
    assert_includes lm.errors.attribute_names, :level
    # model uses alias_attribute :link, :link
    assert_includes lm.errors.attribute_names, :link
  end

  test 'enum levels' do
    assert_equal %w[beginner intermediate expert], LearningMaterial.levels.keys
  end

  test 'search scope returns matches by title' do
    results = LearningMaterial.search('Rails')
    assert results.any?
    assert(results.all? { |lm| lm.title.include?('Rails') })
  end

  test 'by_level scope filters correctly' do
    results = LearningMaterial.by_level('intermediate')
    assert_equal [learning_materials(:rails_intermediate)], results
  end

  test 'featured scope returns only featured' do
    assert_equal [learning_materials(:ruby_basics)], LearningMaterial.featured
  end

  test 'url aliases map to db columns' do
    lm = LearningMaterial.new
    lm.link_url = 'https://example.com'
    lm.thumbnail_url = 'https://example.com/thumb.png'

    assert_equal 'https://example.com', lm.link
    assert_equal 'https://example.com/thumb.png', lm.thumbnail
    assert_equal 'https://example.com', lm.link_url
    assert_equal 'https://example.com/thumb.png', lm.thumbnail_url
  end
end
