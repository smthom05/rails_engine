class Api::V1::Customers::TransactionsController < ApplicationController
  def index
    render json: Invoice.find_by(customer_id: params[:id]).transactions
  end
end
