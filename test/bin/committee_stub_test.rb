require_relative "../test_helper"

describe Committee::Bin::CommitteeStub do
  before do
    @bin = Committee::Bin::CommitteeStub.new
  end

  it "produces a Rack app" do
    app = @bin.get_app(hyper_schema, {})
    assert_kind_of Rack::Builder, app
  end

  it "parses command line options" do
    options, parser = @bin.get_options_parser

    parser.parse!(["--help"])
    assert_equal true, options[:help]

    parser.parse!([
      "--driver", "open_api_2",
      "--tolerant", "true",
      "--port", "1234"
    ])
    assert_equal :open_api_2, options[:driver]
    assert_equal true, options[:tolerant]
    assert_equal "1234", options[:port]
  end

  it "OpenAPI3 not support Stub" do
    assert_raises(Committee::NotSupportOpenAPI3) do
      @bin.get_app(open_api_3_schema, {})
    end
  end
end

describe Committee::Bin::CommitteeStub, "app" do
  include Rack::Test::Methods

  before do
    @bin = Committee::Bin::CommitteeStub.new
  end

  def app
    @bin.get_app(hyper_schema, {})
  end

  it "defaults to a 404" do
    get "/foos"
    assert_equal 404, last_response.status
  end
end
