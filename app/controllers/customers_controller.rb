class CustomersController < ApplicationController

    before_action :set_user, only: [:show, :update, :destroy, :purchase, :cart, :history, :inventory]
    before_action :require_user, only: [:update, :show, :cart, :purchase, :history, :destroy, :inventory]
    before_action :require_same_user, only: [:update, :cart, :purchase, :history, :destroy, :inventory]
    before_action :require_same_user_or_staff, only: [:show]

    def new
        if logged_in?
            redirect_to root_path
        else
            @customer = Customer.new
        end
    end

    def create
        @customer = Customer.new(customer_params)

        if @customer.save 
            flash[:notice] = "Welcome #{@customer.username} to iStore."
            session[:user_id] = @customer.id
            session[:is_staff] = 0
            redirect_to inventory_customer_path(@customer)
        else
            error_messages = @customer.errors.full_messages
            formatted_messages = error_messages.join("\n")
            flash[:alert] = formatted_messages
            redirect_to signup_path
        end
    end

    def show
        
    end

    def update
        if @customer.update(customer_params)
            flash[:notice]="Success"
            redirect_to @customer
        else
            error_messages = @customer.errors.full_messages
            formatted_messages = error_messages.join("\n")
            flash.now[:alert] = formatted_messages
            # @customer = Customer.find(params[:id])
            # redirect_to customer_path(@customer)
            render 'show'
        end
    end

    def destroy
        # @customer.orders.delete_all
        @customer.orders.where(status:2).each do |order|
            item = order.item
            item.quantity += order.quantity 
            item.save
        end
        @customer.destroy
        session[:user_id] = nil
        session[:is_staff] = nil
        redirect_to bye_path
    end

    def cart 
        @item = Item.new
    end

    def inventory
        @items = Item.where(status:true)
        @item = Item.new
    end

    def history
        @customer = current_user
    end

    def purchase  #placed but not fulfilled
        @customer.orders.where(status: 1).each do |order|
            item = Item.find(order.item_id)
            # byebug
            if item.quantity >= order.quantity && item.status == true
                item.quantity -= order.quantity 
                order.status = 2
                if order.save && item.save
                    flash[:notice] = "Orders placed"
                else 
                    flash[:alert] = "Incorrect quantity"
                end
            elsif item.status == true 
                flash[:alert] = "Insufficent Stock for #{item.name} !! Try reducing quantity"
            else
                order.destroy
                flash[:alert] = "Item #{item.name} is no longer in stock"
            end
        end
        @customer.token += 1
        
        @customer.save
        redirect_to cart_customer_path(current_user)
        # inventory verify and update
    end

    private

    def set_user
        begin
          @customer = Customer.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          customer_id = params[:id]
          Order.where(customer_id: customer_id).delete_all
          session[:user_id] = nil
          session[:is_staff] = nil
          redirect_to root_path, flash: { error: "Customer not found." }
        end
      end
      
    def customer_params 
        params.require(:customer).permit(:username, :email, :password, :name, :phone_no)
    end

    def require_same_user
        if current_user != @customer
          flash[:alert] = "You can't do that 444"
          redirect_to root_path
        end
    end

    def require_same_user_or_staff
        if current_user != @customer && !current_user.respond_to?(:is_admin)
          flash[:alert] = "You can't do that 444"
          redirect_to root_path
        end
    end
end