class User < ApplicationRecord
  has_many :questions, dependent: :nullify
  has_many :answers, dependent: :nullify
  has_many :job_posts, dependent: :nullify

  has_many :likes, dependent: :destroy
  # `has_many` can take a `through` named argument to create a
  # many-to-many relationship via another `has_many` declaration.

   # We specify the name of another `has_many` with the `through`
  # option which corresponds to the join table between
  # the two tables that share the many-to-many relationship.

   # We must also provide a `source` named argument to specify
  # which model we're getting back from the many-to-many relationship.


  # has_many :questions, through: :likes # does not work because we
  # already have a has_many :questions on line 2
  has_many :liked_questions, through: :likes, source: :question


  has_secure_password
  # Provides user authentication features on the model
  # it is called in. Requires a column named
  # 'password_digest' and the gem 'bcrypt'
  # - It will add two attribute accessors for 'password'
  # and 'password_confirmation'
  # It will add a presence validation for the 'password'
  # field
  # It will save passwords assigned to 'password' using
  # bcrypt to hash and store it in the 'password_digest'
  # column meaning that we will never store plain text
  # passwords.
  # It will add a method named 'authenticate' to verify
  # a user's password. If called with the correct password,
  # it will return the user. Otherwise, it will return
  # 'false'
  # The attribute accessor 'password_confirmation' is
  # optional. If it is present, a validation will be added
  # to verify that is identical to the 'password' accessor.

  VALID_EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  validates :email, presence: true, uniqueness: true, format: VALID_EMAIL_REGEX, unless: :from_oauth?

  geocoded_by :address
  after_validation :geocode

  def full_name
    "#{first_name} #{last_name}".strip
  end

  serialize :oauth_raw_data
  # Class Methods
  def self.create_from_oauth(oauth_data)
    names = oauth_data["info"]["name"]&.split || oauth_data["info"]["nickname"]
    self.create(
      first_name: names[0],
      last_name: names[1] || "",
      uid: oauth_data["uid"],
      provider: oauth_data["provider"],
      oauth_raw_data: oauth_data,
      password: SecureRandom.hex(32)
    )
  end

  def self.find_by_oauth(oauth_data)
    self.find_by(
      uid: oauth_data["uid"],
      provider: oauth_data["provider"]
    )
  end

  private

  def from_oauth?
    uid.present? && provider.present?
  end
end
