class JobPost < ApplicationRecord
  belongs_to :user
  
  validates :title, presence: true, uniqueness: true
  validates :description, presence: true

  # def self.search(query)
  #   where("title ILIKE ? OR description ILIKE ?", "%#{query}%", "%#{query}%")
  # end
  # Equivalent to:
  scope(:search, -> (query) { where("title ILIKE ? OR description ILIKE ?", "%#{query}%", "%#{query}%") })
end
