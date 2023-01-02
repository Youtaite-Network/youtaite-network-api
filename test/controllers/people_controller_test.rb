require "test_helper"

class PersonControllerTest < ActionDispatch::IntegrationTest
  include AuthHelper

  setup do
    @person1 = people(:one)
    @person2 = people(:two)
  end

  test "index" do
    get people_path
    assert_response :success
    response_body = @response.parsed_body
    assert_equal 2, response_body.size
    assert_equal ["id", "id_type", "misc_id", "name", "thumbnail"], response_body[0].keys.sort
  end

  test "index results can be filtered by id" do
    get people_path, params: {id: @person1.id}
    assert_response :success
    response_body = @response.parsed_body
    assert_equal 1, response_body.size
    assert_equal @person1.id, response_body[0]["id"]
  end

  test "index results can be filtered by id list" do
    get people_path, params: {id: "#{@person1.id},#{@person2.id}"}
    assert_response :success
    response_body = @response.parsed_body
    assert_equal 2, response_body.size
  end

  test "index results can be filtered by id_type" do
    get people_path, params: {id_type: "yt"}
    assert_response :success
    response_body = @response.parsed_body
    assert_equal 1, response_body.size
    assert_equal "yt", response_body[0]["id_type"]
  end

  test "index results can be filtered by id_type list" do
    get people_path, params: {id_type: "yt,tw"}
    assert_response :success
    response_body = @response.parsed_body
    assert_equal 2, response_body.size
  end

  test "index results can be filtered by misc_id" do
    get people_path, params: {misc_id: "misc_id 1"}
    assert_response :success
    response_body = @response.parsed_body
    assert_equal 1, response_body.size
    assert_equal "misc_id 1", response_body[0]["misc_id"]
  end

  test "index results can be filtered by misc_id list" do
    get people_path, params: {role: "misc_id 1,misc_id 2"}
    assert_response :success
    response_body = @response.parsed_body
    assert_equal 2, response_body.size
  end

  test "index results can return a subset of columns" do
    get people_path, params: {fields: "id,created_at,updated_at,misc_id"}
    assert_response :success
    response_body = @response.parsed_body
    assert_equal 2, response_body.size
    assert_equal ["created_at", "id", "misc_id", "updated_at"], response_body[0].keys.sort
  end
end
