class Product < ActiveRecord::Base
	default_scope { order(important: :asc) }
end
