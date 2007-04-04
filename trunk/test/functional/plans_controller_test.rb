require File.dirname(__FILE__) + '/../test_helper'
require 'plans_controller'

# Re-raise errors caught by the controller.
class PlansController; def rescue_action(e) raise e end; end

class PlansControllerTest < Test::Unit::TestCase
  fixtures :plans

  def setup
    @controller = PlansController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = plans(:first).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:plans)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:plan)
    assert assigns(:plan).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:plan)
  end

  def test_create
    num_plans = Plan.count

    post :create, :plan => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_plans + 1, Plan.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:plan)
    assert assigns(:plan).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Plan.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Plan.find(@first_id)
    }
  end
end
