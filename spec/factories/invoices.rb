FactoryBot.define do
  factory :invoice do
    customer { create(:customer) }
    merchant { create(:merchant) }
    status { "MyString" }
  end
end
