# frozen_string_literal: true

require 'logger'
require './lib/database_connector'

class AppConfigurator
  def configure
    setup_i18n
    setup_database
  end

  def token
    secrets['telegram_bot_token']
  end

  def apps_path
    secrets['apps_path']
  end

  def logger
    Logger.new($stdout, Logger::DEBUG)
  end

  def secrets
    @secrets ||= YAML.safe_load(IO.read('config/secrets.yml'))
  end

  private

  def setup_i18n
    I18n.load_path = Dir['config/locales.yml']
    I18n.locale = :en
    I18n.backend.load_translations
  end

  def setup_database
    DatabaseConnector.establish_connection
  end
end
