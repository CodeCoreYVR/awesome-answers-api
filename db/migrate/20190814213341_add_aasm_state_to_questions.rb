class AddAasmStateToQuestions < ActiveRecord::Migration[5.2]
  def change
    add_column :questions, :aasm_state, :string
  end
end
