class ApplicationController < ActionController::Base
    helper_method :current_user, :logged_in?

    def current_user
        if session[:is_staff] == 1
        @current_user ||= Staff.find(session[:user_id]) if session[:user_id]
        else 
        @current_user ||= Customer.find(session[:user_id]) if session[:user_id]
        end
    end

    def logged_in?
        !!current_user
    end

    def require_user
        if !logged_in?
            flash[:alert] = "U must be logged in to do that"
            redirect_to login_path
        end
        
    end

end
