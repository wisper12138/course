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
    get timetable_courses_path
    assert_select "td", "高级软件工程[第2-20周][教1-107]"
  end
end
