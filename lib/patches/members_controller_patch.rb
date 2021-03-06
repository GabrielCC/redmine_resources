# Patches Redmine's MemberController dynamically.
# Save the resource type
module MembersControllerPatch
  def self.included(base) # :nodoc:
    base.extend(ClassMethods)

    base.send(:include, InstanceMethods)

    # Same as typing in the class 
    base.class_eval do
      def create
        if params.has_key?("resource_id") && params[:resource_id] != ''
          resource = Resource.find(params[:resource_id])
        else
          resource = nil
        end
        members = []
        if params[:membership]
          if params[:membership][:user_ids]
            attrs = params[:membership].dup
            user_ids = attrs.delete(:user_ids)
            user_ids.each do |user_id|
              members << Member.new(:role_ids => params[:membership][:role_ids], :user_id => user_id)
            end
          else
            members << Member.new(:role_ids => params[:membership][:role_ids], :user_id => params[:membership][:user_id])
          end
          members.each { |e|
            e.resource = resource
          }
          @project.members << members
        end

        respond_to do |format|
          format.html { redirect_to_settings_in_projects }
          format.js { @members = members }
          format.api {
            @member = members.first
            if @member.valid?
              render :action => 'show', :status => :created, :location => membership_url(@member)
            else
              render_validation_errors(@member)
            end
          }
        end
      end

      def update
        if params[:membership]
          @member.role_ids = params[:membership][:role_ids]
        end
        if params["member-#{@member.id}-resource_id".to_sym]
          resource = Resource.find(params["member-#{@member.id}-resource_id".to_sym])
          @member.resource = resource
        end
        saved = @member.save
        respond_to do |format|
          format.html { redirect_to_settings_in_projects }
          format.js
          format.api {
            if saved
              render_api_ok
            else
              render_validation_errors(@member)
            end
          }
        end
      end

    end

  end
  
  module ClassMethods
  end
  
  module InstanceMethods


  end
end
