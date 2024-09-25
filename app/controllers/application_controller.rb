class ApplicationController < ActionController::Base
    def after_sign_in_path_for(resource)
        if resource.admin?
          admin_loans_path
        else
          loans_path 
        end
      end
end
