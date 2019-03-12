require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'relationships' do
    it {should have_many :invoices}
  end

  describe 'validations' do
  end

  describe 'class methods' do
  end

  describe 'instance methods' do
  end

end
