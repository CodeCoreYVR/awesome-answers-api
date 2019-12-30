class WelcomeController < ApplicationController
  # This file was generated with the command:
  # > rails g controller welcome

  # Public methods inside controllers are
  # are called actions.
  # So this is the index actiom
  def index
    # render "welcome/index"
    # The line above is not need in this case
    # because it is executed by convention (default).

    # By default Rails will render a template
    # within a folder that has the controller name
    # using a file that matches the action name (index
    # in this case) with a default extension of .html.erb

    # This is an example of convention over configuration.
    # We can render whatever we want, but if we stick to
    # the convention, we don't have to write extra code.
    
    # ERB is the default templating system that is shipped with Rails
  end
end
