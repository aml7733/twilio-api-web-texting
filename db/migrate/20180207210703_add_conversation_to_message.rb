class AddConversationToMessage < ActiveRecord::Migration[5.0]
  def change
    add_reference :messages, :conversation, foreign_key: true
  end
end
