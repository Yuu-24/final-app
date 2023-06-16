require "rqrcode"
class ItemsController < ApplicationController

    before_action :require_user, only: [:create, :update, :destroy, :add, :download]
    before_action :require_staff, only: [:create, :update, :destroy, :download]
    
    def create
        @item = Item.new(item_params)

        if @item.save 
            flash[:notice] = "#{@item.name} Added"
            
            redirect_to stock_staff_path(current_user)
        else
            @item = Item.new
            @items = Item.all
            render 'view'
        end
    end

    def update
        @item = Item.find(params[:id])
        # byebug

        if @item.update(params.permit(:name, :price, :quantity))
            flash[:notice]="Success"
        else
            @item = Item.new
            @items = Item.all
        end
        redirect_to stock_staff_path(current_user)
    end

    def destroy
        item = Item.find(params[:id])
        item.destroy

        redirect_to stock_staff_path(current_user)
    end
    
    def download
        item = Item.find(params[:id])
        qrcode = RQRCode::QRCode.new(item.name)
        png = qrcode.as_png(
          size: 300,
          border_modules: 4,
          module_px_size: 6,
          file: nil
        )
      
        # Set the response headers to specify the file type and force download
        headers["Content-Type"] = "image/png"
        headers["Content-Disposition"] = "attachment; filename=\"qr_code_#{item.name.parameterize}.png\""
      
        send_data png.to_s, disposition: :attachment
        # return redirect_to stock_staff_url(current_user)
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
            flash[:alert] = "You can't do that"
            redirect_to root_path
        end 
    end

end
