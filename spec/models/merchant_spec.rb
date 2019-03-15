require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it {should have_many :invoices}
    it {should have_many :items}
  end

  describe 'validations' do
  end

  describe 'class methods' do
    it '.most_revenue' do
      
    end
  end

  describe 'instance methods' do
  end
end
