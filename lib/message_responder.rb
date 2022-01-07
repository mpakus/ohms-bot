# frozen_string_literal: true

require 'English'
require './models/user'
require './models/project'
require './lib/message_sender'

class MessageResponder
  def initialize(options)
    @bot = options[:bot]
    @message = options[:message]
    @user = User.find_or_create_by(uid: message.from.id)
  end

  def respond
    on(%r{^/start}) do
      render I18n.t('start')
    end

    on(%r{^/help}) do
      render I18n.t('help')
    end

    on(%r{^/stop}) do
      render I18n.t('stop')
    end

    on(%r{^/create (.+) (.+)}) do |name, github|
      user.projects.create(name: name, github: github)
      render I18n.t('created', name: name, github: github)
    end

    on(%r{^/list}) do
      projects = user.projects.all.collect{ |p| "#{p.name} #{p.github}"}
      render projects.join("\n")
    end

    on(%r{^/deploy (.*)}) do |branch|

    end

    on(%r{^/redeploy (.*)}) do |branch|

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

  def render_markup(options)
    bot.api.send_message(
      chat_id:      message.chat.id,
      text:         options.fetch(:text),
      reply_markup: options.fetch(:markup)
    )
  end

  def render(text)
    MessageSender.new(bot: bot, chat: message.chat, text: text).send
  end
end
