class AddMailConfirmStateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mail_confirm_state, :string
  end
end
