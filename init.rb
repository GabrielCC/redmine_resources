require "redmine"

# Patches to the Redmine core.
ActionDispatch::Callbacks.to_prepare do 
  require_dependency 'member'
  require 'patches/membership_patch'
  # Guards against including the module multiple time (like in tests)
  # and registering multiple callbacks
  unless Member.included_modules.include? MembershipPatch
    Member.send(:include, MembershipPatch)
  end

  require_dependency 'role'
  require 'patches/resource_setting_patch'
  # Guards against including the module multiple time (like in tests)
  # and registering multiple callbacks
  unless Role.included_modules.include? ResourceSettingPatch
    Role.send(:include, ResourceSettingPatch)
  end

  require_dependency 'tracker'
  # Guards against including the module multiple time (like in tests)
  # and registering multiple callbacks
  unless Tracker.included_modules.include? ResourceSettingPatch
    Tracker.send(:include, ResourceSettingPatch)
  end

  require_dependency 'members_controller'
  require 'patches/members_controller_patch'
  unless MembersController.included_modules.include? MembersControllerPatch
    MembersController.send(:include, MembersControllerPatch)
  end

  require_dependency 'issue'
  require 'patches/issue_patch'
  unless Issue.included_modules.include? IssuePatch
    Issue.send(:include, IssuePatch)
  end

  require 'patches/application_helper_patch'
  require_dependency 'application_helper'
  ApplicationHelper.send(:include, ApplicationHelperPatch) unless ApplicationHelper.included_modules.include? ApplicationHelperPatch

end

Redmine::Plugin.register :redmine_resources do
  name 'Resources plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
  
  # Patches to the Redmine core.

  require_dependency 'hook_listener'


  permission :view_resources_departments, :departments => [:index, :show]
  permission :view_resources_resources, :resources => [:index, :show]
  permission :edit_resources_departments, :departmens => [:edit, :destroy,  :new, :create]
  permission :edit_resources_resources, :resources => [:edit, :destroy, :new, :create]


  menu :admin_menu, :resources_departments, { :controller => 'departments', :action => 'index' }, :caption => 'Departments'
  menu :admin_menu, :resources_resources, { :controller => 'resources', :action => 'index' }, :caption => 'Resources'
  menu :project_menu, :resources_trackers, { :controller => 'trackers', :action => 'index'}, :caption => 'Resources'

  project_module :resources do
    permission :view_resources, :resources => :index
    permission :edit_resources, :resources => :edit
  end
end