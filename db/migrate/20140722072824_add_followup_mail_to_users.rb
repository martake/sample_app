class AddFollowupMailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :followup_mail, :bool, default:true
  end
end
