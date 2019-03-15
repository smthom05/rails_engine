class Api::V1::Invoices::ItemsController < ApplicationController

  def index
    render json: Item.where(invoice_item: {invoice_id: params[:id]})
  end
end
