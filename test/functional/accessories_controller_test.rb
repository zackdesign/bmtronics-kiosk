require File.dirname(__FILE__) + '/../test_helper'
require 'accessories_controller'

# Re-raise errors caught by the controller.
class AccessoriesController; def rescue_action(e) raise e end; end

class AccessoriesControllerTest < Test::Unit::TestCase
  fixtures :accessories

  def setup
    @controller = AccessoriesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = accessories(:first).id
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

    assert_not_nil assigns(:accessories)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:accessory)
    assert assigns(:accessory).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:accessory)
  end

  def test_create
    num_accessories = Accessory.count

    post :create, :accessory => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_accessories + 1, Accessory.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:accessory)
    assert assigns(:accessory).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Accessory.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Accessory.find(@first_id)
    }
  end
end
