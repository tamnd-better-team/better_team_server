class CreateReplyMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :reply_messages do |t|
      t.text :content
      t.integer :user_id
      t.integer :message_id

      t.timestamps
    end
  end
end
