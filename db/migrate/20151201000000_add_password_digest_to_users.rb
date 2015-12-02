class AddPasswordDigestToUsers < ActiveRecord::Migration

  def change
    change_table(:users) do |t|
      t.column :password_digest, :string, :default => 'password1'
    end
  end
end