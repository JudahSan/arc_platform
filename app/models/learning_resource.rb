# frozen_string_literal: true

class LearningResource < ApplicationRecord
  belongs_to :user
end

class User < ApplicationRecord
  has_many :learning_resources
end
