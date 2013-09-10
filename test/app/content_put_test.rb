require 'api_helper'

class ContentPutTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Cms::App
  end

  def setup
    Content.destroy_all
    @alice = User.create name: 'Alice', username: 'alice', password: 'secret'
  end

  def valid_action
    {content: {title: 'Action 1', body: 'Stuff', medium: 'paper'}}.to_json
  end

  def not_logged_in
    {user_id: nil}
  end

  def logged_in
    {user_id: @alice.id}
  end

  def test_must_be_logged_in_to_create_content
    post '/content/actions', valid_action, 'rack.session' => not_logged_in
    assert_equal 401, last_response.status
  end

  def test_must_be_logged_in_to_create_content
    post '/content/actions', valid_action, 'rack.session' => logged_in
    assert_equal 200, last_response.status
    assert_equal 1, Content.count
  end
end
