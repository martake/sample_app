class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :content
      t.integer :user_id
      t.integer :in_direct_to


      t.timestamps
    end
    add_index :messages, [:user_id, :in_direct_to, :created_at]

  end

end
