require File.dirname(__FILE__) + '/../test_helper'
require 'phones_controller'

# Re-raise errors caught by the controller.
class PhonesController; def rescue_action(e) raise e end; end

class PhonesControllerTest < Test::Unit::TestCase
  fixtures :phones

  def setup
    @controller = PhonesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = phones(:first).id
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

    assert_not_nil assigns(:phones)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:phone)
    assert assigns(:phone).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:phone)
  end

  def test_create
    num_phones = Phone.count

    post :create, :phone => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_phones + 1, Phone.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:phone)
    assert assigns(:phone).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Phone.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Phone.find(@first_id)
    }
  end
end
