# frozen_string_literal: true

class CreateTelegramUsers < Sequel::Migration
  def up
    create_table :users do
      primary_key :id
      column :telegram_id, :integer, index: true, unique: true
      column :username, :text
      column :name, :text
      column :step, :text, default: 'start', index: true
      column :role, :text, default: 'user'
      column :access, :boolean, default: false
      column :created_at, DateTime
      column :updated_at, DateTime
    end
  end

  def down
    drop_table :users
  end
end
