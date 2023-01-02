require "test_helper"

class RolesControllerTest < ActionDispatch::IntegrationTest
  include AuthHelper

  setup do
    @user = users(:one)
    @person1 = people(:one)
    @person2 = people(:two)
    @collab1 = collabs(:one)
    @collab2 = collabs(:two)
  end

  test "index" do
    get roles_path
    assert_response :success
    response_body = @response.parsed_body
    assert_equal 4, response_body.size
    assert_equal ["collab_id", "person_id", "role"], response_body[0].keys.sort
  end

  test "index results can be filtered by person_id" do
    get roles_path, params: {person_id: @person1.id}
    assert_response :success
    response_body = @response.parsed_body
    assert_equal 3, response_body.size
    response_body.each { |result| assert_equal @person1.id, result["person_id"] }
  end

  test "index results can be filtered by person_id list" do
    get roles_path, params: {person_id: "#{@person1.id},#{@person2.id}"}
    assert_response :success
    response_body = @response.parsed_body
    assert_equal 4, response_body.size
  end

  test "index results can be filtered by collab_id" do
    get roles_path, params: {collab_id: @collab1.id}
    assert_response :success
    response_body = @response.parsed_body
    assert_equal 3, response_body.size
    response_body.each { |result| assert_equal @collab1.id, result["collab_id"] }
  end

  test "index results can be filtered by collab_id list" do
    get roles_path, params: {collab_id: "#{@collab1.id},#{@collab2.id}"}
    assert_response :success
    response_body = @response.parsed_body
    assert_equal 4, response_body.size
  end

  test "index results can be filtered by role" do
    get roles_path, params: {role: "mix"}
    assert_response :success
    response_body = @response.parsed_body
    assert_equal 2, response_body.size
    response_body.each { |result| assert_equal "mix", result["role"] }
  end

  test "index results can be filtered by role list" do
    get roles_path, params: {role: "mix,art"}
    assert_response :success
    response_body = @response.parsed_body
    assert_equal 3, response_body.size
  end

  test "index results can return a subset of columns" do
    get roles_path, params: {fields: "id,created_at,updated_at,role"}
    assert_response :success
    response_body = @response.parsed_body
    assert_equal 4, response_body.size
    assert_equal ["created_at", "id", "role", "updated_at"], response_body[0].keys.sort
  end

  test "create" do
    ENV.stub(:[], "testing") do
      token = issue_token @user
      post roles_path, headers: {Authorization: "Bearer #{token[:token]}"}, params: {
        role: "vocal",
        person_id: @person1.id,
        collab_id: @collab1.id
      }
    end

    assert_response 201

    created_role = @response.parsed_body
    assert_equal "vocal", created_role["role"]
    assert_equal @person1.id, created_role["person_id"]
    assert_equal @collab1.id, created_role["collab_id"]
    assert_not_nil created_role["id"]
    assert_not_nil created_role["created_at"]
    assert_not_nil created_role["updated_at"]
  end
end
