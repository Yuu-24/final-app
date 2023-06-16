class CustomersController < ApplicationController

    before_action :set_user, only: [:show, :update, :destroy, :purchase, :cart, :history, :inventory]
    before_action :require_user, only: [:update, :show, :cart, :purchase, :history, :destroy, :inventory]
    before_action :require_same_user, only: [:update, :show, :cart, :purchase, :history, :destroy, :inventory]

    def new
        @customer = Customer.new
    end

    def create
        @customer = Customer.new(customer_params)

        if @customer.save 
            flash[:notice] = "Welcome Traveller #{@customer.username} to new world."
            session[:user_id] = @customer.id
            session[:is_staff] = 0
            redirect_to customer_path(@customer)
        else
            render 'new'
        end
    end

    def show
    end

    def update
        if @customer.update(customer_params)
            flash[:notice]="Success"
            redirect_to @customer
        else
            @customer = Customer.find(params[:id])
            render 'show'
        end
    end

    def destroy
        @customer.orders.delete_all
        @customer.destroy
        session[:user_id] = nil
        session[:is_staff] = nil
        redirect_to bye_path
    end

    def cart 
        @item = Item.new
    end

    def inventory
        @items = Item.all
        @item = Item.new
    end

    def history
        @customer = current_user
    end

    def purchase  #placed but not fulfilled
        @customer.orders.where(status: 1).each do |order|
            item = Item.find(order.item_id)
            # byebug
            if item.quantity >= order.quantity
                item.quantity -= order.quantity 
                order.status = 2
                if order.save && item.save
                    flash[:notice] = "Orders plced"
                else 
                    flash[:alert] = "Incorrect quantity"
                end
            else
                flash[:alert] = "Insufficent Stock for #{item.name} !! Try reducing quantity"
            end
        end
        @customer.token += 1
        
        @customer.save
        redirect_to cart_customer_path(current_user)
        # inventory verify and update
    end

    private

    def set_user
        @customer = Customer.find(params[:id])
    end

    def customer_params 
        params.require(:customer).permit(:username, :email, :password, :name, :phone_no)
    end

    def require_same_user
        if current_user != @customer
          flash[:alert] = "You can't do that"
          redirect_to root_path
        end
    end
end