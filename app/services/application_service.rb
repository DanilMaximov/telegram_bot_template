# frozen_string_literal: true

require 'dry/initializer'

class ApplicationService
  extend Dry::Initializer

  def self.call(*args, **options, &block)
    new(*args, **options).call(&block)
  end

  def call(**)
    raise NotImplementedError, '#call is not implemented'
  end
end
