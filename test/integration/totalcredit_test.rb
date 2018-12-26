require 'test_helper'

class TotalcreditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:student)
    @course1 = courses(:one)
  end

  test "get totalcredit" do
    log_in_as(@user)
    assert_redirected_to controller: :homes, action: :index
    follow_redirect!
    assert_template 'homes/index'
    get select_course_path(@course1)
    get totalcredit_courses_path
    assert_select "td", @course1.credit[-3..-1]
  end 
end
