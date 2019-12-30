class Question < ApplicationRecord
  # This is the Question model. We generated this
  # file with the command:
  # rails g model question title:string body:text
  # This command also generates a migration file
  # in db/migrate

  # Rails will add attr_accessors for all columns
  # of the table (i.e. title, body, created_at, updated_at)

  # Adding 'dependent: :destroy' option tells Rails to
  # delete associated records before deleting the record
  # itself. In this case, when a question is deleted
  # its answers are deleted first to satisfy the foreign
  # key constraint.
  # You can also use 'dependent: :nullify' which will
  # cause all associated answers to have their question_id
  # column set to NULL before the question is destroyed.

  # If you don't use either dependent option, you can end
  # up with answers in your db referencing question_ids
  # that no longer exist, likely leading to errors.
  # Always set a dependent option to help maintain
  # referential integrity.
  belongs_to :user
  has_many(:answers, dependent: :destroy)
  # has_many(:answers, dependent: :destroy) adds
  # the following instance methods to the Question model:

  # .answers
  # .answers<<(object, ...)
  # .answers.delete(object, ...)
  # .answers.destroy(object, ...)
  # .answers=(objects)
  # .answers_singular_ids
  # .answers_singular_ids=(ids)
  # .answers.clear
  # .answers.empty?
  # .answers.size
  # .answers.find(...)
  # .answers.where(...)
  # .answers.exists?(...)
  # .answers.build(attributes = {}, ...)
  # .answers.create(attributes = {})
  # .answers.create!(attributes = {})
  # .answers.reload

  # Many to Many :likes
  # one way to define Many to Many
  # has_and_belongs_to_many :likes # but this way is discouraged because its too rigid

  has_many :likes, dependent: :destroy
  has_many :likers, through: :likes, source: :user # this association is dependent on the has_many :likes association

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings#, source: :tag
  # If the name of the association (i.e. :tags)
  # is the same as the source singularized (i.e. :tag)
  # then the source argument can be omitted.
  has_one_attached :image


  # Create validations by using the 'validates' method
  # The arguments are (in order):
  # - A column name as a symbol
  # - Named arguments, corresponding to the validation
  # rules

  # To read more on validations, go to:
  # https://guides.rubyonrails.org/active_record_validations.html

  validates(:title, presence: true, uniqueness: true)

  validates(
    :body,
    presence: {message: "must exist"},
    length: { minimum: 10 }
  )

  validates(
    :view_count,
    numericality: {greater_than_or_equal_to: 0, allow_blank: true}
  )

  # Custom validation
  # The method for custom validations is singular
  # unlike the 'validates' method for regular validations
  validate :no_monkey

  # before_validation is a lifecycle callback
  # method that allows to respond to events during
  # the life of a model instance (i.e. being validated,
  # being created, being updated etc.)
  # All lifecycle callback methods take a symbol
  # named after a method and calls that method
  # at the appropriate time.
  before_validation(:set_default_view_count)

  include AASM

  aasm whiny_transitions: false do
    # Set the initial state for new instances
    # with 'initial: true'
    state :draft, initial: true
    state :published
    state :answered
    state :not_answered
    state :archived

    event :publish do
      transitions from: :draft, to: :published
    end

    event :answer do
      transitions from: [:not_answered, :published], to: :answered
    end

    event :no_answer do
      transitions from: :published, to: :not_answered
    end

    event :archive do
      transitions to: :archived
    end
  end



  #  For all available methods go to:
  # https://guides.rubyonrails.org/active_record_callbacks.html#available-callbacks
  def cool_view_count
    view_count
  end

  # Create a scope with a class method
  # https://edgeguides.rubyonrails.org/active_record_querying.html#scopes

  # def self.recent
  #   order(created_at: :desc).limit(10)
  # end

  # Scopes are such a commonly used feature, that
  # there's another way to create them quicker. It
  # takes a name and a lambda as a callback
  scope(:recent, -> { order(created_at: :desc).limit(10) })

  scope(:viewable, -> {
      where(aasm_state: [:published, :answered, :not_answered])
    })

  # def self.search(query)
  #   where("title ILIKE ? OR body ILIKE ?", "%#{query}%", "%#{query}%")
  # end
  # Equivalent to:
  scope(:search, -> (query) { where("title ILIKE ? OR body ILIKE ?", "%#{query}%", "%#{query}%") })



  def tag_names
    self.tags.map{ |tag| tag.name }.join(", ")
  end

  # Appending = at the end of a method name, allows
  # us to implement a setter. A setter is a method that
  # is assignable

  # Example:
  # q.tag_names = "stuff, yo"

  # The code in the example above would call the method below, where the value on the right hand side of the = ("stuff, yo") would become the argument to the method (rhs)
  def tag_names=(rhs)
    self.tags = rhs.strip.split(/\s*,\s*/).map do |tag_name|
      # Finds the first record with the given
      # attributes, or initializes a record (Tag.new)
      # with the attributes if one is not found.
      Tag.find_or_initialize_by(name: tag_name)
    end
  end
  private

  def no_monkey
    # &. is the safe navigation operator. It's used
    # like the . operator to call methods on an object.
    # If the method doesn't exist for the object, 'nil'
    # will be returned instead of getting an error
    if body&.downcase&.include?("monkey")
      # To make a record invalid. You must add a
      # validation error using the 'errors' 'add' method
      # It's arguments (in order):
      # - A symbol for the invalid column
      # - A error message as a string
      self.errors.add(:body, "must not have monkeys")
    end
  end

  def set_default_view_count
    # If you are a writing to an attribute accessor, you
    # must prefix with 'self.' Which you don't need to do
    # if you are reading it instead.
    self.view_count ||= 0
  end

end
