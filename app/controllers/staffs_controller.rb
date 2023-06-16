class StaffsController < ApplicationController

    before_action :set_user, only: [:show, :update, :destroy, :stock, :orders]
    before_action :require_user, only: [:new, :update, :index, :stock, :show,  :orders, :create, :destroy]
    before_action :require_same_user, only: [:update, :orders, :destroy, :stock] 
    before_action :require_admin, only: [:new]
    before_action :require_staff, only: [:index]


    def new
        @staff = Staff.new
    end

    def create
        @staff = Staff.new(staff_params)

        if @staff.save 
            flash[:notice] = "Welcome Traveller #{@staff.username} to new world."
            session[:user_id] = @staff.id
            session[:is_staff] = 1
            redirect_to staff_path(@staff)
        else
            flash[:alert] = "Invalid Details"
            render 'new'
        end
    end

    def show
    end

    def index
        @staffs = Staff.all
    end

    def update

        if @staff.update(staff_params)
            flash[:notice]="Success"
            redirect_to @staff
        else
            flash[:alert] = "Invalid Details"
            @staff = Staff.find(params[:id])
            render 'show'
        end
    end

    def destroy
        @staff.active = 0
        @staff.save
        session[:user_id] = nil
        session[:is_staff] = nil
        redirect_to bye_path
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
    end

    def staff_params 
        params.require(:staff).permit(:username, :email, :password, :name, :phone_no)
    end

    def require_same_user
        if current_user != @staff
            byebug
          flash[:alert] = "You can't do that"
          redirect_to root_path
        end
    end

    def require_admin
        if current_user.is_admin != true
            # byebug
            flash[:alert] = "Admin privileges required"
            redirect_to root_path
        end 
    end

    def require_staff
        # byebug
        if !current_user.respond_to?(:is_admin)
            flash[:alert] = "You can't do that to me"
            redirect_to root_path
        end 
    end
end