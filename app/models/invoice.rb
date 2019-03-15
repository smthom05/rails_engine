class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions

  # def self.most_revenue(limit = 5)
  #   Invoice.select("invoices.*, sum(invoice_items.quantity * invoice_items.unit_price) AS revenue")
  #          .joins(:invoice_items, :transactions)
  #          .merge(Transaction.unscoped.successful)
  #          .group(:id)
  #          .order("revenue desc")
  #          .limit(limit)
  # end
end
