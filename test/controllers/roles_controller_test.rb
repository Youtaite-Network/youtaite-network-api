require "test_helper"

class RolesControllerTest < ActionDispatch::IntegrationTest
  include AuthHelper

  setup do
    ENV["SESSION_SECRET"] = "abcd"
    @user = users(:one)
    @person = people(:one)
    @collab = collabs(:one)
  end

  test "index" do
    get roles_path
    assert_response :success
    response_body = @response.parsed_body
    assert_equal 4, response_body.size
    assert_equal ["collab_id", "person_id", "role"], response_body[0].keys.sort
  end

  test "index results can be filtered by person_id" do
    get roles_path, params: {person_id: 1}
    assert_response :success
    response_body = @response.parsed_body
    assert_equal 3, response_body.size
    response_body.each { |result| assert_equal 1, result["person_id"] }
  end

  test "index results can be filtered by collab_id" do
    get roles_path, params: {collab_id: 1}
    assert_response :success
    response_body = @response.parsed_body
    assert_equal 3, response_body.size
    response_body.each { |result| assert_equal 1, result["collab_id"] }
  end

  test "index results can be filtered by role" do
    get roles_path, params: {role: "mix"}
    assert_response :success
    response_body = @response.parsed_body
    assert_equal 2, response_body.size
    response_body.each { |result| assert_equal "mix", result["role"] }
  end

  test "index results can return a subset of columns" do
    get roles_path, params: {fields: "id,created_at,updated_at,role"}
    assert_response :success
    response_body = @response.parsed_body
    assert_equal 4, response_body.size
    assert_equal ["created_at", "id", "role", "updated_at"], response_body[0].keys.sort
  end

  test "create" do
    token = issue_token @user
    post roles_path, headers: {Authorization: "Bearer #{token[:token]}"}, params: {
      role: "vocal",
      person_id: @person.id,
      collab_id: @collab.id
    }
    assert_response 201

    created_role = @response.parsed_body
    assert_equal "vocal", created_role["role"]
    assert_equal @person.id, created_role["person_id"]
    assert_equal @collab.id, created_role["collab_id"]
    assert_not_nil created_role["id"]
    assert_not_nil created_role["created_at"]
    assert_not_nil created_role["updated_at"]
  end
end
