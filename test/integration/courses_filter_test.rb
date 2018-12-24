require 'test_helper'

class CoursesFilterTest < ActionDispatch::IntegrationTest

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


  test "courses filter1" do
    log_in_as(@user)
    assert_redirected_to controller: :homes, action: :index
    follow_redirect!
    assert_template 'homes/index'
    get list_courses_path
    post list_courses_path, parmas: {'course_time'=>'周五(2-4)', 'course_credit'=>'', 'course_type'=>''}
    assert_response :success 
  end
  
    test "courses filter2" do
    log_in_as(@user)
    assert_redirected_to controller: :homes, action: :index
    follow_redirect!
    assert_template 'homes/index'
    get list_courses_path
    post list_courses_path, parmas: { "course_time"=>"周五(2-4)", "course_credit"=>"60/3.0", "course_type"=>""}
    assert_response :success 
  end
  
  test "courses filter3" do
    log_in_as(@user)
    assert_redirected_to controller: :homes, action: :index
    follow_redirect!
    assert_template 'homes/index'
    get list_courses_path
    post list_courses_path, parmas: { "course_time"=>"周五(2-4)", "course_credit"=>"60/3.0", "course_type"=>"专业核心课"}
    assert_response :success 
  end

end
