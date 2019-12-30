class AddLikeCountToQuestions < ActiveRecord::Migration[5.2]
  def change
    add_column :questions, :like_count, :integer
  end
end
