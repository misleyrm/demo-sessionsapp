class SessionsUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :sessions_users do |t|
      t.belongs_to :session, index: true, foreign_key: true
      t.belongs_to :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
