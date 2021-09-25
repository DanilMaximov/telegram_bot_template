# frozen_string_literal: true

require 'aasm'

class User < Sequel::Model(DB)
  unrestrict_primary_key
  plugin :timestamps, update_on_create: true

  include AASM

  aasm :roles, column: :role do
    state :user, default: true
    state :admin

    event :make_admin do
      transitions to: :admin
    end

    event :make_user do
      transitions to: :user
    end
  end

  aasm :steps, column: :step do
    state :start, default: true
    state :set_currency

    event :set_currency do
      transitions to: :set_currency
    end

    event :start do
      transitions to: :start
    end
  end

  def admin?
    role == ::ApplicationBot::ADMIN
  end
end
