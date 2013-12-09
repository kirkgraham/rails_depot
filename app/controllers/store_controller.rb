class StoreController < ApplicationController
  def index
  	@products = Product.order(:title)
  	@time = Time.now

  	@counter = session[:counter]
  	@counter.nil? ? @counter = 1 : @counter += 1
  	session[:counter] = @counter
  end
end
