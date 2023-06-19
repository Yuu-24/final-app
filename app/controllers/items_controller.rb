require "rqrcode"
class ItemsController < ApplicationController

    before_action :require_user, only: [:new, :create, :update, :destroy, :add, :download, :revive]
    before_action :require_staff, only: [:new, :create, :update, :destroy, :download, :revive]
    before_action :require_customer, only: [:add]

    def new
        @item = Item.new
    end
    
    def create
        @item = Item.new(item_params)

        if @item.save 
            flash[:notice] = "#{@item.name} Added"
            
            redirect_to stock_staff_path(current_user)
        else
            # @item = Item.new
            error_messages = @item.errors.full_messages
            formatted_messages = error_messages.join("\n")
            flash[:alert] = formatted_messages
            redirect_to new_item_path
        end
    end

    def update
        @item = Item.find(params[:id])
        # byebug

        if @item.update(params.permit(:price, :quantity))
            flash[:notice]="Success"
        else
            error_messages = @item.errors.full_messages
            formatted_messages = error_messages.join("\n")
            flash[:alert] = formatted_messages
        end
        redirect_to stock_staff_path(current_user)
    end

    def destroy
        item = Item.find(params[:id])
        item.status = false 
        item.orders.where(status:2).each do |order|
            order.status = 4
            item.quantity += order.quantity 
            order.save 
        end
        item.save

        flash[:alert] = "#{item.name} will no longer be shown in catalogue !!"
        redirect_to stock_staff_path(current_user)
    end
    
    def revive 
        item = Item.find(params[:id])
        item.status = true 
        item.save
        flash[:notice] = "#{item.name} is added back to stock !!"
        redirect_to stock_staff_path(current_user)
    end

    def download
        item = Item.find(params[:id])
        qrcode = RQRCode::QRCode.new(item.name)
        png = qrcode.as_png(
          size: 300,
          border_modules: 4,
          module_px_size: 6
        )
      
        # Set the response headers to specify the file type and force download
        send_data png.to_s,
                  type: 'image/png',
                  filename: "qr_code_#{item.name.parameterize}.png",
                  disposition: 'attachment'
      end
      


    def add
        # byebug
        item = Item.find(params[:id])
        customer = current_user
        # byebug

        if params[:quantity].to_i > item.quantity
            flash[:alert]="Insuffcient Stock !! Try reducing quantity"
        else
            order = customer.orders.find_by(status: 1, item_id: item.id)
            order.destroy if order

            order = Order.new(item: item, customer: customer)
            order.quantity = params[:quantity]
            order.price = order.quantity * item.price
            order.token = customer.token

            # byebug

            # item.quantity -= params[:quantity].to_i
            if order.save
                flash[:notice]="Item added to cart"
            else
                # item.quantity += params[:quantity].to_i
                flash[:alert]="Invalid Quantity"
            end
        end
        orders=Order.all
        redirect_to inventory_customer_path(customer)
    end

    private

    def item_params 
        params.require(:item).permit(:name, :price, :quantity)
    end

    def require_staff
        # byebug
        if !current_user.respond_to?(:is_admin)
            flash[:alert] = "You can't do that 111"
            redirect_to root_path
        end 
    end

    def require_customer
        # byebug
        if current_user.respond_to?(:is_admin)
            flash[:alert] = "You can't do that 555"
            redirect_to root_path
        end 
    end

end
