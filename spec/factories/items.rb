FactoryBot.define do
  factory :item do
    name { "Sandwich" }
    description { "Is it a sandwich?" }
    unit_price { 1 }
    merchant { nil }
  end
end
