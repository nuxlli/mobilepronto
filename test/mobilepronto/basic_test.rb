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

    it "should skiped invalid parameters to query string build" do
      stub_http_request(:get, @kclass.config.url_api).to_return(:body => "000").with(:query => {
        "CREDENCIAL" => "XXXX"
      })
      assert_equal :ok, @kclass.send_msg(
        :credencial => "XXXX",
        :invalid_item => "foobar"
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

    it "should remove accentuation if option is set" do
      stub_http_request(:get, @kclass.config.url_api).to_return(:body => "000").with(:query => {
        "MESSAGE"        => "Sr. Antonio, nao compareca, isto nao e uma brincadeira."
      })

      assert_equal :ok, @kclass.send_msg(
        message: 'Sr. Antônio, não compareça, isto não é uma brincadeira.',
        transliterate: true
      )
    end

    it "should abbr string if mark to abbr. and size exceeded the message limit" do
      primary_msg = "Olá [abbr]Daniel Boo Sulivan[/abbr], Shoreditch artisan retro quis nulla. Portland thundercats helvetica, proident placeat artisan eiusmod sunt sustainable. Single-origin cof"
      final_msg   = "Olá Daniel B. Sulivan, Shoreditch artisan retro quis nulla. Portland thundercats helvetica, proident placeat artisan eiusmod sunt sustainable. Single-origin cof"

      stub_http_request(:get, @kclass.config.url_api).to_return(:body => "000").with(:query => {
        "MESSAGE"  => final_msg
      })

      assert_equal :ok, @kclass.send_msg(
        message: primary_msg
      )
    end

    it "should abbr string if mark to abbr. and size exceeded the message limit" do
      primary_msg = "Olá [abbr]Daniel Boo Sulivan[/abbr] Shoreditch artisan retro quis nulla. Portland thundercats helvetica proident placeat artisan eiusmod sunt sustainable. Single-origin cof"
      final_msg   = "Olá Daniel B. S. Shoreditch artisan retro quis nulla. Portland thundercats helvetica proident placeat artisan eiusmod sunt sustainable. Single-origin cof"

      stub_http_request(:get, @kclass.config.url_api).to_return(:body => "000").with(:query => {
        "MESSAGE"        => final_msg,
        "PRINCIPAL_USER" => "TEST",
        "SEND_PROJECT"   => "S"
      })

      assert_equal :ok, @kclass.send_msg(
        message: primary_msg,
        project_name: "TEST",
        send_project: true
      )
    end

    it "should remove mark addr if size not exceded the message limit" do
      primary_msg = "Olá [abbr]Daniel Boo Sulivan[/abbr]."
      final_msg   = "Olá Daniel Boo Sulivan."

      stub_http_request(:get, @kclass.config.url_api).to_return(:body => "000").with(:query => {
        "MESSAGE"  => final_msg
      })

      assert_equal :ok, @kclass.send_msg(
        message: primary_msg
      )
    end
  end
end
