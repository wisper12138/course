class CoursesController < ApplicationController

  before_action :student_logged_in, only: [:select, :quit, :list]
  before_action :teacher_logged_in, only: [:new, :create, :edit, :destroy, :update, :open, :close]#add open by qiao
  before_action :logged_in, only: :index

  #-------------------------for teachers----------------------

  def new
    @course=Course.new
  end

  def create
    @course = Course.new(course_params)
    if @course.save
      current_user.teaching_courses<<@course
      redirect_to courses_path, flash: {success: "新课程申请成功"}
    else
      flash[:warning] = "信息填写有误,请重试"
      render 'new'
    end
  end

  def edit
    @course=Course.find_by_id(params[:id])
  end

  def update
    @course = Course.find_by_id(params[:id])
    if @course.update_attributes(course_params)
      flash={:info => "更新成功"}
    else
      flash={:warning => "更新失败"}
    end
    redirect_to courses_path, flash: flash
  end
  
 
    
  def open
    @course=Course.find_by_id(params[:id])
    @course.update_attributes(open: true)
    redirect_to courses_path, flash: {:success => "已经成功开启该课程:#{ @course.name}"}
  end

  def close
    @course=Course.find_by_id(params[:id])
    @course.update_attributes(open: false)
    redirect_to courses_path, flash: {:success => "已经成功关闭该课程:#{ @course.name}"}
  end

  def destroy
    @course=Course.find_by_id(params[:id])
    current_user.teaching_courses.delete(@course)
    @course.destroy
    flash={:success => "成功删除课程: #{@course.name}"}
    redirect_to courses_path, flash: flash
  end

  #-------------------------for students----------------------

  def list
    #-------QiaoCode--------
    def get_course_info(courses, type)
      res = Set.new
      courses.each do |course|
        res.add(course[type])
      end
      res.to_a.sort
    end
    
    def check_course_condition(course, key, value)
      if value == '' or course[key] == value
        return true
      end
      false
    end

    tmp_conflicted_courses = []
    @courses = Course.all
    @course = @courses-current_user.courses
    @current_user_courses = @courses - @course
    @course_time = get_course_info(@course, 'course_time')
    @course_credit = get_course_info(@course, 'credit')
    @course_type = get_course_info(@course, 'course_type')
    
    @course.each do |course|
      @current_user_courses.each do |current_user_courses|
        if current_user_courses.course_time == course.course_time
          course.class_room = current_user_courses.name
          tmp_conflicted_courses << course
        end
      end
    end
    
    @tmp_conflicted_courses = tmp_conflicted_courses

    if request.post?
      res = []
      @course.each do |course|
        if check_course_condition(course, 'course_time', params['course_time']) and
            check_course_condition(course, 'course_type', params['course_type']) and
            check_course_condition(course, 'credit', params['course_credit']) and
          res << course
        end
        @course=res
      end
    end
    
  end
  
 def timetable
  def week_data_to_num(week_data)
    param = {
        '周一' => 0,
        '周二' => 1,
        '周三' => 2,
        '周四' => 3,
        '周五' => 4,
        '周六' => 5,
        '周天' => 6,
    }
    param[week_data] + 1
  end
  #生成11行7列的数据
  def get_current_curriculum_table(courses,user)
    # course_time = Array.new(11) { Array.new(7, '') }
    course_time = Array.new(11) {Array.new(7) {Array.new(3, '')}}
    courses.each do |cur|
      real_course_name = cur.name
      
      cur_time = String(cur.course_time)
      end_j = cur_time.index('(')#index第一次出现的字节位置 end_j=2
      j = week_data_to_num(cur_time[0...end_j])
      t = cur_time[end_j + 1...cur_time.index(')')].split("-")
      for i in (t[0].to_i..t[1].to_i).each
        course_time[(i-1)*7/7][j-1][0] = real_course_name
        course_time[(i-1)*7/7][j-1][1] = cur.course_week
        course_time[(i-1)*7/7][j-1][2] = cur.class_room
      end
    end
    course_time
  end
  
  
    @course=current_user.courses
    @current_user_course=current_user.courses
    @user=current_user
    @course_time_table = get_current_curriculum_table(@course,@user)#当前课表
 end
 
  def coursedetails
    @course=Course.find_by_id(params[:id])
   
  end

  def swap
    @course = Course.find_by_id(params[:id])
    @current_user_courses=current_user.courses
    
    @current_user_courses.each do |current_user_course|
      if  current_user_course.course_time == @course.course_time
        @info = current_user_course.name
        current_user.courses.delete(current_user_course)
        break
      end
    end    
      
    current_user.courses << @course
    flash = {:success => "成功换课"}
    redirect_to courses_path, flash: flash
  end

  def select
    @course=Course.find_by_id(params[:id])
    current_user.courses<<@course
    flash={:suceess => "成功选择课程: #{@course.name}"}
    redirect_to courses_path, flash: flash
  end

  def quit
    @course=Course.find_by_id(params[:id])
    current_user.courses.delete(@course)
    flash={:success => "成功退选课程: #{@course.name}"}
    redirect_to courses_path, flash: flash
  end


  #-------------------------for both teachers and students----------------------

  def index
    @course=current_user.teaching_courses.paginate(page: params[:page], per_page: 4) if teacher_logged_in?
    @course=current_user.courses.paginate(page: params[:page], per_page: 4) if student_logged_in?
  end


  private

  # Confirms a student logged-in user.
  def student_logged_in
    unless student_logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end

  # Confirms a teacher logged-in user.
  def teacher_logged_in
    unless teacher_logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end



  # Confirms a  logged-in user.
  def logged_in
    unless logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end

  def course_params
    params.require(:course).permit(:course_code, :name, :course_type, :teaching_type, :exam_type,
                                   :credit, :limit_num, :class_room, :course_time, :course_week)
  end


end
