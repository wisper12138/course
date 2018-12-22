require 'test_helper'

class CourseSwapTestTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:student)
    @course1 = courses(:one)
    @course2 = courses(:two)
  end
  
  def log_in_as(user, password: 'password', remember_me: '1')
    post sessions_login_path(params: {session: { email: user.email,
                                                 password: password,
                                                 remember_me: remember_me } })
  end

  test "courses conflited and swap" do
    log_in_as(@user)
    assert_redirected_to controller: :homes, action: :index
    follow_redirect!
    assert_template 'homes/index'
    get select_course_path(@course1)
    assert_redirected_to courses_path
    assert_not flash.empty?
    get list_courses_path
    assert_select 'td','一键换课'
  end
end
