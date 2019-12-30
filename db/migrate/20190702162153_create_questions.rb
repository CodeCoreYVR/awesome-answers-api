class CreateQuestions < ActiveRecord::Migration[5.2]
  # This is the Question model. We generated this
  # file with the command:
  # rails g model question title:string body:text

  # To run all your remaining(pending) migrations do:
  # rails db:migrate

  # To look at the status of migrations (whether they are
  # active or not) do:
  # rails db:migrate:status

  # To reverse the last migration do:
  # rails db:rollback
  def change
    create_table :questions do |t|
      t.string :title
      t.text :body

      t.timestamps
      # This will create two columns, "created_at"
      #  and "updated_at" which will auto update.
    end
  end
end
