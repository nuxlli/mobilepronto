# encoding: UTF-8

require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

describe MobilePronto::Basic do
  before do
    @kclass = Class.new(MobilePronto)
  end

  it "should be configurable" do
    original = MobilePronto.config.url_api
    @kclass.configure do |config|
      config.url_api = "http://localhost"
    end
    assert_equal "http://localhost", @kclass.config.url_api
    assert_equal original, MobilePronto.config.url_api
  end

  describe "send_msg method" do
    it "should build a query string using the parameters" do
      stub_http_request(:get, @kclass.config.url_api).to_return(:body => "000").with(:query => {"CREDENCIAL" => "XXX"})
      assert_equal :ok, @kclass.send_msg(credencial: "XXX")
      assert_equal :ok, @kclass.send_msg('credencial' => "XXX")
    end

    it "should merge parameters and configs in query string" do
      stub_http_request(:get, @kclass.config.url_api).to_return(:body => "000").with(:query => {"CREDENCIAL" => "XXX"})
      @kclass.configure { |c| c.credencial = 'XXX' }
      assert_equal :ok, @kclass.send_msg
    end

    it "should translate all parameters to query string correct" do
      stub_http_request(:get, @kclass.config.url_api).to_return(:body => "000").with(:query => {
        "CREDENCIAL"     => "XXX",
        "PRINCIPAL_USER" => "PROJECT",
        "AUX_USER"       => "USER",
        "MOBILE"         => "559999999999",
        "SEND_PROJECT"   => "S",
        "MESSAGE"        => "Message of test"
      })
      assert_equal :ok, @kclass.send_msg(
        :credencial   => "XXX",
        :project_name => "PROJECT",
        :user_name    => "USER",
        :mobile       => 559999999999,
        :send_project => true,
        :message      => "Message of test"
      )
    end

    it "should raise exception is returns not equal 000" do
      stub_http_request(:get, @kclass.config.url_api).to_return(:body => "001")
      assert_raises(MobilePronto::SendError, "001 - Credencial Inválida.") do
        @kclass.send_msg()
      end
    end

    it "should allow use block to analyser response" do
      stub_http_request(:get, @kclass.config.url_api)
        .to_return(:body => "000")
        .to_return(:body => "001")
        .to_return(:body => "010")

      assert_equal("Message sent", @kclass.send_msg do |result|
        result.on(:ok) { "Message sent" }
      end)

      assert_equal("001 - Credencial Inválida.", @kclass.send_msg do |result|
        result.on(1) { result.error.message }
      end)

      assert_equal("010 - Gateway Bloqueado.", @kclass.send_msg do |result|
        result.on(1..17) { result.error.message }
      end)
    end
  end
end