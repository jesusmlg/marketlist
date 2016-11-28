class ProductsController < ApplicationController
	before_action :allowed?

	def index
		@products = Product.where(comprado: 0)
		@product  = Product.new
	end

	def new
	end

	def buy
		@marcados = params
	end
	
	def restore
		@products = Product.all	
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

	def restore
		@products = Product.where(comprado: 1)
		@product  = Product.new
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
					redirect_to root_path
				end
			end
		end
end
