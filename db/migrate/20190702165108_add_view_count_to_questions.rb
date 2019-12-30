class AddViewCountToQuestions < ActiveRecord::Migration[5.2]
  #  To generate a migration file do:
  # rails g migration <name of migration>
  def change
    # Use the add_column method to add columns to
    # a table. It's arguments are (in order):
    # - the table's name as a symbol
    # - the new column's name as a symbol
    # - The type of the new column
    add_column :questions, :view_count, :integer
  end
end
