class OrdersController < ApplicationController

    before_action :require_user, only: [:create, :update, :destroy, :add, :download,:fulfill, :unfulfill]
    before_action :require_staff, only: [:fulfill, :unfulfill]

    def update 
        order = Order.find(params[:id])
        item = order.item 
        # old_quantity = order.quantity.to_i
        available = item.quantity.to_i  
        new_quantity = params[:quantity].to_i

        # byebug

        if new_quantity <= available 
            order.quantity = new_quantity
            order.price = order.quantity * item.price
            # item.quantity = old_quantity + available - new_quantity
            order.created_at = Time.now
            if order.save
                flash[:notice]="Cart Updated"
            else
                flash[:alert]="Not a valid quantity"
            end
        else
            flash[:alert]="Insuffcient Stock !! Try reducing quantity"
        end
        redirect_to cart_customer_path(current_user)
    end
    def destroy
        order = Order.find(params[:id])
        order.destroy
        redirect_to cart_customer_path(current_user)
    end

    def fulfill
        # byebug
        order=Order.find(params[:id])
        order.status = 3
        order.save
        # Orders.where(status: 2).update_all(status: 3)
        redirect_to orders_staff_path(current_user)
    end
    
    def unfulfill
        # byebug
        order=Order.find(params[:id])
        order.status = 4
        item = Item.find(order.item_id)
        item.quantity += order.quantity
        item.save
        order.save
        # Orders.where(status: 2).update_all(status: 3)
        redirect_to orders_staff_path(current_user)
    end

    private

    def require_staff
        # byebug
        if !current_user.respond_to?(:is_admin)
            flash[:alert] = "You can't do that 222"
            redirect_to root_path
        end 
    end
end