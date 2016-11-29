class ProductsController < ApplicationController
	#before_action :allowed?

	def index
		myOrder = orderBy(params[:order])

		@products = Product.where(comprado: 0).order(myOrder)
		@product  = Product.new
	end

	def restore
		myOrder = orderBy(params[:order])

		@products = Product.where(comprado: 1).order(myOrder)
		@product  = Product.new
	end

	def orderBy(order)
		if order.nil?
			order = "updated_at"
		end

		if order == "updated_at" then
			order+= " DESC"
		end

		return order
	end


	def new

	end

	def buy
		@marcados = params
	end
	

	def create
		@product = Product.new(products_params)
		@product.comprado = 0
		@product.user = session[:user]
		if @product.save
			flash[:success] = "Producto guardado correctamente"
			redirect_to root_path
		else
			flash[:danger] = "Error al guardar el producto"
			render 'index'
		end
	end

	def remove_restore_from_list
		ids_to_remove = params[:checkedValues].split(",")
		
		ids_to_remove.each do |id|
			@product = Product.find(id)
			@product.user = session[:user]
			
			if params[:task] == "remove"
				@product.comprado = 1
				@product.save
			elsif params[:task] == "restore"
				@product.comprado = 0
				@product.save
			elsif params[:task] == "delete"
				@product.destroy	
			end				
				
		end

		redirect_to products_path
	end

	private
		def products_params
			params.require(:product).permit(:name,:user)
		end

		def allowed?
			if session[:user].nil?
				if params[:pass]!=ENV['OPENSHIFT_MARKETLIST_JMLGKEY']
					redirect_to 'http://www.google.es'
				else
					session[:user] = params[:user]
					redirect_to list_to_buy_path
				end
			end
		end
end
