# frozen_string_literal: true

require 'sequel'

db_config_file = File.join(File.dirname(__FILE__), "../database.yml")

config = YAML.safe_load(File.read(db_config_file))[Application.env]

DB = Sequel.connect(config)
DB.timezone = :utc
# DB.use_iso_date_format = false

Sequel.default_timezone = :utc
Sequel::Model.plugin :timestamps, create: :created_on, update: :updated_on, update_on_create: true

Sequel.extension :migration
Sequel::Migrator.run(DB, File.join(File.dirname(__FILE__), '../../db/migrations/'))
