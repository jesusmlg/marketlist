class ProductsController < ApplicationController
	
	include ActionView::Helpers::UrlHelper

	before_action :allowed?

	def index
		myOrder = orderBy(params[:order])
		session[:list_id] = params[:list_id]

		@products = Product.where(comprado: 0,list_id: params[:list_id]).order(myOrder)
		@product  = Product.new
	end

	def restore
		myOrder = orderBy(params[:order])
		session[:list_id] = params[:list_id]

		@products = Product.where(comprado: 1,list_id: params[:list_id]).order(myOrder)
		@product  = Product.new
	end

	def orderBy(order)
		if order.nil?
			order = "name"
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

		return product
	end

	def create
		@product = Product.new(products_params)
		@product.comprado = 0
		@product.user = session[:user]
		@product.list_id = session[:list_id]

		producInList = inList?(@product.name)

		if producInList.nil?
			if @product.save
				flash[:success] = ("<b>#{@product.name}</b> guardado correctamente").html_safe
			else
				flash[:danger] = "Error al guardar el producto"
			end
		elsif producInList.comprado == 0
			flash[:warning] = "El producto ya está en la lista!"
		elsif producInList.comprado == 1
			#flash[:warning] = ("El producto <b>"+producInList.name+"</b> está en la lista de eliminados, si quieres recuperarlo pincha "+ link_to('aquí', restore_from_bought_path(producInList), method: :post)).html_safe
			if restore_from_bought(producInList) then
				flash[:warning] = ("El producto <b>"+producInList.name+"</b> se ha restaurado de la lista de eliminados").html_safe
			else
				flash[:danger] = ("El producto <b>"+producInList.name+"</b> NO se ha podido restaurar de la lista de eliminados").html_safe
			end
		else	
			flash[:warning] = "Algo extraño ha sucedido "
		end
		
		redirect_to(list_to_buy_path(order: 'name', list_id: params[:list_id]))
		
	
	end

	def restore_from_bought
		@product = Product.find(params[:id])
		@product.comprado = 0

		if @product.save
				flash[:success] = "Producto restaurado correctamente"
			else
				flash[:danger] = "Error al restaurar el producto"
		end
		
		
		redirect_to list_to_buy_path
	end

	def restore_from_bought(product)
		@product = Product.find(product.id)
		@product.comprado = 0
		@product.user = session[:user]

		return @product.save
		
	end

	def remove_restore_from_list
		ids_to_remove = params[:checkedValues].split(",")
		
		ids_to_remove.each do |id|
			@product = Product.find(id)
			@product.important = false
			
			if params[:task] == "remove"
				@product.comprado = 1
				@product.save
			elsif params[:task] == "restore"
				@product.comprado = 0
				@product.user = session[:user]
				@product.save
			elsif params[:task] == "delete"
				@product.destroy	
			end				
				
		end

		redirect_to list_to_buy_path
	end

	def check_important
		@product = Product.find(params[:id])

		@product.important = !@product.important

		@product.save

		redirect_to list_to_buy_path
	end

	private
		def products_params
			params.require(:product).permit(:name,:user,:list_id)
		end

		def allowed?
			if session[:user].nil? && cookies[:marketlm].nil?
				redirect_to login_path
			elsif !cookies[:marketlm].nil?
				session[:user] = cookies[:marketlm]
			end
		end
end
