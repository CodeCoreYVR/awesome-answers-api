class ContactsController < ApplicationController
  def new
  end

  def create
    # We define instance variables here to be able
    # to access the variable in the corresponding
    # view file.
   @name = params["name"]
   @message = params["message"]
  end
end
