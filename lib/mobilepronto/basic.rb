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
      if params.delete(:transliterate) and params.include?(:message)
        params[:message] = ActiveSupport::Inflector.transliterate(params[:message])
      end

      unless params[:send_project].nil?
        params[:send_project] = params[:send_project] ? 'S' : 'N'
      end

      params.map { |k, v| keys.key?(k) ? "#{keys[k]}=#{URI.escape(v.to_s)}" : nil }.compact.join("&")
    end
  end
end
