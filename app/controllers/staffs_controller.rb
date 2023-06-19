class StaffsController < ApplicationController

    before_action :set_user, only: [ :update, :destroy, :stock, :orders]
    before_action :require_user, only: [:new, :update, :index, :stock, :show,  :orders, :create, :destroy]
    before_action :require_staff, only: [:new, :update, :index, :stock, :show,  :orders, :create, :destroy]
    before_action :require_same_user, only: [:update, :destroy, :orders, :create, :stock] 
    before_action :require_admin, only: [:new]


    def new
        @staff = Staff.new
    end

    def create
        @staff = Staff.new(staff_params)

        if @staff.save 
            flash[:notice] = "#{@staff.name} added."
            redirect_to staffs_path
        else
            flash[:alert] = "Invalid Details"
            render 'new'
        end
    end

    def show
        @staff = Staff.find(params[:id])
    end

    def index
        @staffs = Staff.all
    end

    def update

        if @staff.update(staff_params)
            flash[:notice]="Success"
            redirect_to @staff
        else
            flash.now[:alert] = "Invalid Details"
            @staff = Staff.find(params[:id])
            render 'show'
        end
    end

    def destroy
        @staff.active = 0
        @staff.save

        if current_user == @staff 
            session[:user_id] = nil
            session[:is_staff] = nil
            redirect_to bye_path
        else   
            flash[:notice] = "#{@staff.name} got removed"
            redirect_to staffs_path 
        end
    end

    def orders
        @orders = Order.where(status:2)
    end

    def stock
        @item = Item.new
        @items = Item.all
    end

    private

    def set_user
        @staff = Staff.find(params[:id])

        if !@staff.active
            session[:user_id] = nil
            session[:is_staff] = nil
            redirect_to root_path, flash: { error: "Staff Member not found." }
        end
    end

    def staff_params 
        params.require(:staff).permit(:username, :email, :password, :name, :phone_no)
    end

    def require_same_user
        if current_user != @staff && current_user.is_admin == false
          flash[:alert] = "You can't do that to 333"
          redirect_to root_path
        end
    end

    def require_admin
        if current_user.is_admin != true
            
            flash[:alert] = "Admin privileges required"
            redirect_to root_path
        end 
    end

    def require_staff
        if !current_user.respond_to?(:is_admin)
            flash[:alert] = "You don't have necessary rights"
            redirect_to root_path
        end 
    end
end