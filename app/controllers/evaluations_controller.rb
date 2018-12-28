class EvaluationsController < ApplicationController

	#sgg10
	def edit
	  @course=Course.find_by_id(params[:id])

    #nskk5
    @itemscount=Evaluationitem.count
    @itemsid=Array.new(@itemscount,0)
    @itemscontent=Array.new(@itemscount,"评价项")

    evaluationitems=Evaluationitem.all
    i=0
    index_last=0
    evaluationitems.each do |e|
        @itemsid[i]=e.id 
        i=i+1
        if e.itemcontent=="总体评价"
          index_last=e.id
        end
    end
    @itemsid.sort!
    puts @itemsid
    j=0
    @itemsid.each do |i|
        if i==index_last
          break
        else 
          j=j+1
        end
    end
    
    if j==@itemscount-1
       puts @itemsid
    else
       for i in j..@itemscount-2
        @itemsid[i]=@itemsid[i+1]
       end
       @itemsid[@itemscount-1]=index_last 
       puts @itemsid
    end

    for k in 0..@itemscount-1
       @itemscontent[k]=Evaluationitem.find_by_id(@itemsid[k]).itemcontent
       puts @itemscontent[k]
    end    
        
	end 

	#sgg11
  #nskk6
	def insert
    @course=Course.find_by_id(params[:id])

    count=Evaluationitem.count
    ids=Array.new(count,0)

    evaluationitems=Evaluationitem.all
    i=0
    index_last=0
    evaluationitems.each do |e|
        ids[i]=e.id 
        i=i+1
        if e.itemcontent=="总体评价"
          index_last=e.id
        end
    end
    ids.sort!
    puts ids
    j=0
    ids.each do |i|
        if i==index_last
          break
        else 
          j=j+1
        end
    end
    if j==count-1
       puts ids
    else
       for i in j..count-2
         ids[i]=ids[i+1]
       end
       ids[count-1]=index_last 
       puts ids
    end


    for i in 1..count
      name=":score#{i}"
      if params[name].nil?
        flash[:danger] = "信息填写不全,请填写完整后再保存!"
        redirect_to edit_evaluation_url(@course)
        return
      end
    end 
    
		for k in 1..count
       name=":score#{k}"
       insert_record(current_user.id,@course.id,ids[k-1],params[name].to_i)
    end

    flash[:info] = "评估成功!"
    redirect_to evaluation_index_courses_path 

	end

	#sgg12
  #nskk7
	def insert_record(user_id,course_id,evaluationitem_id,score)
        evaluation1=Evaluation.where(:user_id=>user_id,:course_id=>course_id,:evaluationitem_id=>evaluationitem_id).first
        if evaluation1.nil? 
          evaluation1=Evaluation.new
		      evaluation1.user_id=user_id
          evaluation1.course_id=course_id
          evaluation1.evaluationitem_id=evaluationitem_id
          evaluation1.score=score
          evaluation1.save                                           
        else
          evaluation1.update_attributes(:score=>score)
        end		
	end

  #sgg14  admin evaluation index page
  def index
    @selectcontent=params[:selectcontent]
    if @selectcontent.nil? || @selectcontent.empty?
      @courses = Course.all.order("id ASC").paginate(page: params[:page], per_page: 8)
    else
      selectedusers=User.where(" name LIKE '%#{@selectcontent}%' and teacher=true").all
      selectedusersids= Array.new
      selectedusers.each do |s|
        selectedusersids << s.id
      end 
      puts selectedusersids.length
      
      if selectedusersids.length==0
         @courses = Course.where(" name LIKE '%#{@selectcontent}%' or course_code LIKE '%#{@selectcontent}%' ").all.paginate(page: params[:page], per_page: 4)
      else 
         ids=selectedusersids.join(',')
         @courses = Course.where(" name LIKE '%#{@selectcontent}%' or course_code LIKE '%#{@selectcontent}%' or teacher_id in (#{ids}) ").all.paginate(page: params[:page], per_page: 4)
      end 
    end

  end

  #nskk1
  def items
    @evaluationitems=Evaluationitem.all.order("id ASC");
  end

  #nskk3
  def itemupdate
    if params[:evaluationitem][:itemcontent].nil? or params[:evaluationitem][:itemcontent]=="" or params[:evaluationitem][:itemcontent].lstrip==""
      redirect_to items_evaluations_path, flash: {:danger => "评估项不能为空!"}
    else
      @Evaluationitem=Evaluationitem.find_by_id(params[:id])
      @Evaluationitem.update_attributes(:itemcontent=>params[:evaluationitem][:itemcontent])
      redirect_to items_evaluations_path,flash: {info: "修改评估项成功!"}
    end
  end

  #nskk4
  def itemdelete
    @Evaluationitem=Evaluationitem.find_by_id(params[:id])
    evaluations_foritem=Evaluation.where(:evaluationitem_id=>@Evaluationitem.id).all
    evaluations_foritem.each do |e|
       e.destroy
    end

    @Evaluationitem.destroy
    redirect_to items_evaluations_path, flash: {:info => "成功删除!"}
  end

  #nskk5
  def itemadd
    if params[:itemcontent].nil? or params[:itemcontent]=="" or params[:itemcontent].lstrip==""
      redirect_to items_evaluations_path, flash: {:danger => "评估项不能为空!"}
    else
      addevaluationitem=Evaluationitem.new
      addevaluationitem.itemcontent= params[:itemcontent]
      addevaluationitem.save 
      redirect_to items_evaluations_path, flash: {:info => "成功增加评估项!"}
    end
  end

  #sgg15
  def result
    @course=Course.find_by_id(params[:id])

    #nskk6
    @itemscount=Evaluationitem.count
    @itemsid=Array.new(@itemscount,0)
    @itemscontent=Array.new(@itemscount,"评价项")

    evaluationitems=Evaluationitem.all
    i=0
    index_last=0
    evaluationitems.each do |e|
        @itemsid[i]=e.id 
        i=i+1
        if e.itemcontent=="总体评价"
          index_last=e.id
        end
    end
    @itemsid.sort!
    puts @itemsid
    j=0
    @itemsid.each do |i|
        if i==index_last
          break
        else 
          j=j+1
        end
    end
    
    if j==@itemscount-1
       puts @itemsid
    else
       for i in j..@itemscount-2
        @itemsid[i]=@itemsid[i+1]
       end
       @itemsid[@itemscount-1]=index_last 
       puts @itemsid
    end

    for k in 0..@itemscount-1
       @itemscontent[k]=Evaluationitem.find_by_id(@itemsid[k]).itemcontent
       puts @itemscontent[k]
    end    
    

    @labels=Array.new(@itemscount){Array.new(4,"0")} 
    for h in 0..@itemscount-1
      for g in 0..3
        @labels[h][g]=getLabelForItem(@course.id,@itemsid[h],g+1)
      end 
    end 

    @results=getNumForItem(@course.id,@itemsid[@itemscount-1])


  end

  #sgg16
  def getLabelForItem(course_id,item,score)
    num1=Evaluation.where(:course_id=>course_id,:evaluationitem_id=>item,:score=>1).count
    num2=Evaluation.where(:course_id=>course_id,:evaluationitem_id=>item,:score=>2).count
    num3=Evaluation.where(:course_id=>course_id,:evaluationitem_id=>item,:score=>3).count
    num4=Evaluation.where(:course_id=>course_id,:evaluationitem_id=>item,:score=>4).count
    count=num1+num2+num3+num4
    

    if count==0
      label="  得票数 0   0%"
    else
      if score==1
        percent=format("%.2f",format("%.4f",num1.to_f/count).to_f*100)
        label="  得票数 #{num1}   #{percent}%"
      end
      if score==2
        percent=format("%.2f",format("%.4f",num2.to_f/count).to_f*100)
        label="  得票数 #{num2}   #{percent}%"
      end
      if score==3
        percent=format("%.2f",format("%.4f",num3.to_f/count).to_f*100)
        label="  得票数 #{num3}   #{percent}%"
      end
      if score==4
        percent=format("%.2f",format("%.4f",num4.to_f/count).to_f*100)
        label="  得票数 #{num4}   #{percent}%"
      end
    end

    return label
  end

  #sgg19
  def getNumForItem(course_id,item)
    num1=Evaluation.where(:course_id=>course_id,:evaluationitem_id=>item,:score=>1).count
    num2=Evaluation.where(:course_id=>course_id,:evaluationitem_id=>item,:score=>2).count
    num3=Evaluation.where(:course_id=>course_id,:evaluationitem_id=>item,:score=>3).count
    num4=Evaluation.where(:course_id=>course_id,:evaluationitem_id=>item,:score=>4).count
    count=num1+num2+num3+num4
    
    if count==0
      result=[10000,10000,10000,10000]
    else
      result=[num1,num2,num3,num4]
    end

    return result
  end

  #sgg25
  def openfeedback
    @course=Course.find_by_id(params[:id])
    @course.update_attributes(:isopen=>"1")
    redirect_to evaluations_path,flash: {info: "开通教师查看权限成功!"}
  end 

  def closefeedback
    @course=Course.find_by_id(params[:id])
    @course.update_attributes(:isopen=>"0")
    redirect_to evaluations_path,flash: {info: "关闭教师查看权限成功!"}
  end
end