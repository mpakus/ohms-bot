# frozen_string_literal: true

require 'telegram/bot'
require './lib/message_responder'
require './lib/app_configurator'

if !ENV["RAILS_ENV"]
  ENV["RAILS_ENV"] = ENV["DB"] || ENV["RACK_ENV"] || 'development'
end

config = AppConfigurator.new
config.configure
token = config.token
logger = config.logger

logger.debug 'Starting OhMyS Bot'

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    options = { bot: bot, message: message }

    logger.debug "@#{message.from.username}: #{message.text}"
    MessageResponder.new(options).respond
  end
end
