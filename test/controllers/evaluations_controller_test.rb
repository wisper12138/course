require 'test_helper'

class EvaluationsControllerTest < ActionController::TestCase
  
  # test example
  test "EvaluationsControllerTest example" do
    assert true
    assert_raises(NameError) do
       indexevaluations
    end
  end
  

  # def setup
  #   @user = users(:peng)
  # end

  test "should get itemsindex" do
    get :items
    assert_response :success
  end

  test "should PATCH itemupdate" do
    # patch itemupdate_evaluation_path(:id=>"2")
    #patch :itemupdate, params:{id:2}
    #patch "/evaluations/2/itemupdate",params:{"id"=>"2","evaluationitem"=>{"itemcontent"=>"无调课、停课、替讲现象"}, "commit"=>"保存"}
    patch :itemupdate, id: 2,evaluationitem:{"itemcontent"=>"无调课、停课、替讲现象"}
    assert_redirected_to items_evaluations_path
    # assert_response :success
  end

  test "should PATCH itemupdate null value" do
    patch :itemupdate, id: 2,evaluationitem:{"itemcontent"=>""}
    assert_redirected_to items_evaluations_path
  end

  test "should delete itemdelete" do
  	@beforedelete=Evaluationitem.count
    delete :itemdelete, id: 2
    @afterdelete=Evaluationitem.count
    assert_equal(@beforedelete,@afterdelete+1)
    
    assert_redirected_to items_evaluations_path
  end

  test "should add itemadd" do
  	@beforeadd=Evaluationitem.count
    #post "/evaluations/itemcontent/itemadd", itemcontent: "item1"
    #post itemadd_evaluation_path(:itemcontent), itemcontent: "item1"
    #post "/itemcontent/itemadd"
    #post "itemcontent/itemadd"
    #post "itemadd"
    #post  "/itemcontent/itemadd",params:{ itemcontent: "item1"}
    post :itemadd,itemcontent:"item1"
    @afteradd=Evaluationitem.count
    assert_equal(@beforeadd,@afteradd-1)
    assert_redirected_to items_evaluations_path
  end

  test "should add itemadd null value" do
  	@beforeadd=Evaluationitem.count
    post :itemadd
    @afteradd=Evaluationitem.count
    assert_equal(@beforeadd,@afteradd)
    assert_redirected_to items_evaluations_path
  end

  test "should get index " do
     get :index,selectcontent:"计"
      assert_response :success
  end

  test "should get index null value" do
     get :index,selectcontent:""
      assert_response :success
  end

  test "should get result " do
     get :result,id:1
     assert_response :success
  end

  test "should student get edit  " do
     get :edit,id:1
     assert_response :success
  end

  test "should student get insert  " do
     @course=Course.all.first
     post :insert,id: @course
     assert_redirected_to edit_evaluation_url(@course)     
  end


end
