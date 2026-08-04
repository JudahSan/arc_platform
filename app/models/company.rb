# frozen_string_literal: true

class Company < ApplicationRecord
  has_one_attached :logo

  validates :name, presence: true
  validates :country, presence: true
  validates :slug, presence: true, uniqueness: true

  before_validation :generate_slug, if: -> { name.present? && (slug.blank? || name_changed?) }

  scope :published, -> { where(published: true) }
  scope :featured, -> { where(featured: true) }

  def to_param
    slug
  end

  private

  def generate_slug
    base_slug = name.parameterize
    candidate_slug = base_slug
    counter = 1

    while Company.where(slug: candidate_slug).where.not(id: id).exists?
      candidate_slug = "#{base_slug}-#{counter}"
      counter += 1
    end

    self.slug = candidate_slug
  end
end
