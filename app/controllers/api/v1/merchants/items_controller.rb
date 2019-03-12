class Api::V1::Merchants::ItemsController < ApplicationController
  def index
<<<<<<< HEAD
    binding.pry
=======
>>>>>>> f7bfcbe3ddec67f301f3754738aeeb4d476a5202
    render json: Merchant.find(params[:id]).items
  end

end
