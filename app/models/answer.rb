class Answer < ApplicationRecord
  # Rails guide on Associations:

  # By default, 'belongs_to' will create a validation
  # such as:
  # 'validates :question_id, presence: true'
  # It can be disabled by passing the option
  # 'optional: true' to the belongs_to method

  # In an association between two models, the model that
  # has the 'belongs_to' is always the one who's table
  # contains the foreign_key column (i.e. question_id)
  belongs_to :question
  belongs_to :user

  # The following instance methods are added to the
  # Answer model with the line belongs_to :question.
  # They simplify interaction with the associated
  # question
  # .question
  # .question=(associate)
  # .build_question(attributes = {})
  # .create_question(attributes = {})
  # .create_question!(attributes = {})
  # .reload_question

  validates :body, presence: true
end
