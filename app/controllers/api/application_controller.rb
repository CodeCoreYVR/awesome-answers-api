class Api::ApplicationController < ApplicationController

  # When making POST, DELETE, & PATCH requests to
  # our controllers, Rails requires that an authenticity
  # token is included as part of the params. Normally
  # Rails will add this to any form generated with
  # form helper methods (i.e. form_with, form_for,etc.)
  # This prevents third-parties from making such
  # requests to our Rails application. It is a
  # security mesaure that is uneccessary in the
  # context of a Web API. We use the following to skip
  # that verification.
  skip_before_action(:verify_authenticity_token)

  private

  def authenticate_user!
    unless current_user.present?
      render(json: { status: 401 }, status: 401 )
    end
  end
end
