require "test_helper"

class TourismControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get tourism_index_url
    assert_response :success
  end
end
