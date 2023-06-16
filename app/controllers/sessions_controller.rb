require 'securerandom'
class SessionsController < ApplicationController
    def new
    end

    def create
        if params[:session][:staff_login] == "1"
            user = Staff.find_by(username: params[:session][:username].downcase)
            session[:is_staff] = 1
        elsif params[:session][:staff_login] == "0"
            user = Customer.find_by(username: params[:session][:username].downcase)
            session[:is_staff] = 0
        end

        if user && user.authenticate(params[:session][:password])
            # session[:hash] = SecureRandom.hex(32)
            if session[:is_staff] == 1
                if !user.active 
                    flash[:alert] = "Wrong Credentials"
                    session[:is_staff] = nil
                    redirect_to login_path
                else
                    session[:user_id] = user.id
                    flash[:notice] = "Welcome back"
                    redirect_to orders_staff_path(user)
                end
            else
                session[:user_id] = user.id
                flash[:notice] = "Welcome back"
                redirect_to cart_customer_path(user)
            end
        else
            session[:is_staff] = nil
            flash.now[:alert] = "Wrong Credentials"
            render 'new'
        end
        
    end

    def destroy
        session[:user_id] = nil
        session[:is_staff] = nil
        redirect_to bye_path
    end
    def bye
    end
end
