# encoding: UTF-8
require 'active_support/configurable'
require 'active_support/inflector'
require 'active_support/core_ext/hash'

class MobilePronto
  module Basic
    def self.extended(base)
      base.send(:include, ActiveSupport::Configurable)
    end

    def send_msg(options = {}, &block)
      request(options.merge(config), &block)
    end

    private

    def request(params)
      query     = build_query(params)
      uri       = URI.parse(config.url_api)
      uri.query = query != "" ? query : nil
      http      = Net::HTTP.new(uri.host, uri.port)
      request   = Net::HTTP::Get.new(uri.request_uri)
      response  = http.request(request)
      if (response.body != "000")
        error = SendError.new(response.body)
        block_given? ? yield(Result.new(response.body, error)) : raise(error)
      else
        block_given? ? yield(Result.new(:ok)) : :ok
      end
    end

    def build_query(params)
      keys = {
        :credencial   => 'CREDENCIAL',
        :project_name => 'PRINCIPAL_USER',
        :user_name    => 'AUX_USER',
        :mobile       => 'MOBILE',
        :send_project => 'SEND_PROJECT',
        :message      => 'MESSAGE'
      }

      params.symbolize_keys!

      if params.include?(:message)
        if params.delete(:transliterate)
          params[:message] = ActiveSupport::Inflector.transliterate(params[:message])
        end

        limit = 160
        limit = limit - ((params[:project_name] || "" ).size + 1) if params[:send_project]

        if (msg = /(.*)\[abbr\](.*)\[\/abbr\](.*)/.match(params[:message]))
          max = limit - (msg[1..3].join('').size - msg[2].size)
          params[:message] = "#{msg[1]}#{Abbreviation.abbr(msg[2], max)}#{msg[3]}"
        end
      end

      unless params[:send_project].nil?
        params[:send_project] = params[:send_project] ? 'S' : 'N'
      end

      params.map { |k, v| keys.key?(k) ? "#{keys[k]}=#{URI.escape(v.to_s)}" : nil }.compact.join("&")
    end
  end
end
