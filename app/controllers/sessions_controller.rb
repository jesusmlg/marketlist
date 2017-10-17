class SessionsController < ApplicationController
	
	def login
		
	end

	def check_login
		if(params[:session][:pass] == ENV['OPENSHIFT_MARKETLIST_JMLGKEY'])
			session[:user] = params[:session][:user]
			cookies[:marketlm] = { value: params[:session][:user], expires: 2.months.from_now } 
			redirect_to(list_to_buy_path(order: 'name', list_id: params[:list_id]))
		else
			flash[:danger] = "Contraseña incorrecta"
			render 'login'
		end
	end

	def logout
		session[:user] = nil
	end


end
