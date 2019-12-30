class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email, index: {unique: true}
      # Add an index to columns that you query often
      # It will improve the performance of the query
      # significantly as the db grows in size.
      # An index acheives this by creating an
      # ordered list (a binary tree technically) that
      # gives the db a faster way to searchg for
      # values in that column.
      t.string :password_digest

      t.timestamps
    end
    # If you needed to add it to an existing table:
    # add_index :users, :email, unique: true
  end
end
