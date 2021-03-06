require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
  it {should belong_to :merchant}
  it {should have_many :invoice_items}
  it {should have_many(:invoices).through :invoice_items}

  end

  describe 'validations' do
  end

  describe 'class methods' do
  end

  describe 'instance methods' do
  end
end
