class Product < ActiveRecord::Base
	default_scope { order(important: :desc) }
end
