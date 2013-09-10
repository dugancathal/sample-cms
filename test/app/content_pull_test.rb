require 'api_helper'

class ContentPullTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Cms::App
  end

  def setup
    @content = Content.create(title: 'Do something smart!',
      body: 'When you do something smart, good things happen',
      medium: 'web',
      type: 'action'
    ) 
  end

  def teardown
    Content.destroy_all
  end

  def test_can_pull_all_content
    get '/content/actions'
    assert_equal 200, last_response.status
    assert_equal Content.where(type: 'action').count, JSON.parse(last_response.body).count
  end

  def test_can_limit_content_scope_by_type
    get '/content/challenges'
    assert_equal 200, last_response.status
    assert_equal Content.where(type: 'challenge').count, JSON.parse(last_response.body).count
  end

  def test_can_limit_content_scope_by_medium
    get '/content/actions', medium: 'paper'
    assert_equal 200, last_response.status
    assert_equal Content.where(medium: 'paper').count, JSON.parse(last_response.body).count
  end

  def test_can_pull_a_single_piece_by_id
    get "/content/actions/#{@content.id}"
    assert_equal 200, last_response.status
    assert_equal JSON.parse(@content.to_json), JSON.parse(last_response.body)
  end
end
