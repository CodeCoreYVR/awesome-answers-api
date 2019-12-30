class CreateAnswers < ActiveRecord::Migration[5.2]
  # This file was generated with the command:
  # rails g model answer body:text question:references
  def change
    create_table :answers do |t|
      t.text :body
      t.references :question, foreign_key: true

      # The above creates a 'question_id' column
      # of type 'big_int'. It also sets a foreign_key
      # constraint to enforce the association to the
      # questions table at the db level. The question_id
      # will refer to the id of the question in the
      # questions table. It is said that the answer
      # 'belongs to' the question.

       # As of Rails 5, this will also add an index
       # to the foreign key field (in this case
       # question_id ). If you don't want an index
       # you can pass the option: 'index: false'

       # Big Int can go from -9_223_372_036_854_775_807
      # to 9223372036854775807.

      # Int can go from -2_147_483_648 to 2147483648

      t.timestamps
    end
  end
end
