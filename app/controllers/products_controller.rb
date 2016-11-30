class ProductsController < ApplicationController
	
	include ActionView::Helpers::UrlHelper

	before_action :allowed?

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
	
	def inList?(product)

		product = Product.where('lower(name) = lower(?)', product).first

		if product.nil? #si el producto NO está en niguna lista lista
			return 0
		elsif product.comprado == 0 #si el producto está en la lista para COMPRARLO
			return 1
		elsif product.comprado == 1 #si el producto está en la lista para RECUPERARLO
			return 2
		else # resto de casos, no debería existir
			return 99
		end
	end

	def create
		@product = Product.new(products_params)
		@product.comprado = 0
		@product.user = session[:user]

		producInList = inList?(@product.name)

		if producInList == 0
			if @product.save
				flash[:success] = "Producto guardado correctamente"
			else
				flash[:danger] = "Error al guardar el producto"
			end
		elsif producInList == 1
			flash[:warning] = "El producto ya está en la lista!"
		elsif producInList == 2
			flash[:warning] = "El producto está en la lista de eliminados, recupéralo!"
		else	
			flash[:warning] = "Algo extraño ha sucedido "
		end

		redirect_to list_to_buy_path
	
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

		redirect_to list_to_buy_path
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
			elsif !session[:user].nil? && session[:user]!=params[:user] && current_page?("/in/#{params[:pass]}/#{params[:user]}")
					session[:user] = params[:user]
					redirect_to list_to_buy_path
			end
		end
end
