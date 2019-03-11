FactoryBot.define do
  factory :item do
    name { "MyString" }
    descrption { "MyText" }
    unit_price { 1 }
    merchant { nil }
  end
end
