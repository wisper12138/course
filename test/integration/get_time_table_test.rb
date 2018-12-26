require 'test_helper'

class GetTimeTableTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:student)
    @course1 = courses(:one)
  end

  test "get time table and details" do
    log_in_as(@user)
    assert_redirected_to controller: :homes, action: :index
    follow_redirect!
    assert_template 'homes/index'
    get select_course_path(@course1)
    get timetable_course_url
    assert_select "td", @course1.name
    get coursedetails_course_path(@course1)
    assert_response :success
    assert_select "h3", @course1.name
  end
end
