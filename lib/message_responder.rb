# frozen_string_literal: true

require 'English'
require './models/user'
require './lib/message_sender'

class MessageResponder
  def initialize(options)
    @bot = options[:bot]
    @message = options[:message]
    @user = User.find_or_create_by(uid: message.from.id)
  end

  def respond
    on(%r{^/start}) do
      answer_with_greeting_message
    end

    on(%r{^/help}) do
      answer_with_help_message
    end

    on(%r{^/stop}) do
      answer_with_farewell_message
    end

    on(%r{^/create}) do
      answer_with_farewell_message
    end

    on(%r{^/list}) do
      answer_with_farewell_message
    end

    # on(%r{^/add (.+)}) do |arg| # supports up to two arguments but it is easily extendable
    #   # do your stuff
    # end
  end

  private

  attr_reader :message, :bot, :user

  def on(regex, &block)
    regex =~ message.text

    if $LAST_MATCH_INFO
      case block.arity
      when 0
        yield
      when 1
        yield Regexp.last_match(1)
      when 2
        yield Regexp.last_match(1), Regexp.last_match(2)
      end
    end
  end

  def answer_with_greeting_message
    answer_with_message I18n.t('start')
  end

  def answer_with_help_message
    answer_with_message I18n.t('help')
  end

  def answer_with_farewell_message
    answer_with_message I18n.t('stop')
  end

  def render_markup(options)
    bot.api.send_message(
      chat_id:      message.chat.id,
      text:         options.fetch(:text),
      reply_markup: options.fetch(:markup)
    )
  end

  def answer_with_message(text)
    MessageSender.new(bot: bot, chat: message.chat, text: text).send
  end
end
