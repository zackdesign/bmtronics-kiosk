# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_bmtronics_session_id'

uses_tiny_mce(:options => {:theme => "advanced",
  :browsers => %w{msie gecko},
  :theme_advanced_toolbar_location => "top",
  :theme_advanced_toolbar_align => "left",
  :theme_advanced_resizing => true,
  :theme_advanced_resize_horizontal => false,
  :plugins => %w{contextmenu paste}},
  :only => [:new, :edit, :show, :index])
end
