class Badge < ApplicationRecord
  belongs_to :question

  validates :title, :image, presence: true
end
