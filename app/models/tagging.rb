class Tagging < ApplicationRecord
  belongs_to :tag
  belongs_to :question

  # Each tag can only be applied to a question once.
  validates(:tag_id, uniqueness: { scope: :question_id })
end
