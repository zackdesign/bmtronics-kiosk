require File.dirname(__FILE__) + '/../test_helper'
require 'plan_groups_controller'

# Re-raise errors caught by the controller.
class PlanGroupsController; def rescue_action(e) raise e end; end

class PlanGroupsControllerTest < Test::Unit::TestCase
  def setup
    @controller = PlanGroupsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
