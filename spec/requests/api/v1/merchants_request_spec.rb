require 'rails_helper'

describe "Merchants API" do
  it 'sends a list of merchants' do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    merchants = JSON.parse(response.body)["data"]

    expect(response).to be_successful
    expect(merchants.count).to eq(3)
  end

  it 'can get a merchant by its id' do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"]["attributes"]["id"]).to eq(id)
  end

  it 'can get a merchant by its name' do
    name = create(:merchant).name

    get "/api/v1/merchants/find?name=#{name}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"]["attributes"]["name"]).to eq(name)
  end

  it 'can get a merchant by its created at time' do
    created_at = create(:merchant, id: 60, created_at: "2012-03-27 14:54:05 UTC").created_at

    get "/api/v1/merchants/find?created_at=#{created_at}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    # expect(merchant["data"]["attributes"]["created_at"]).to eq("2012-03-27T14:54:05.000Z")
    expect(merchant["data"]["attributes"]["id"]).to eq(60)
  end

  it 'can get a merchant by its updated at time' do
    updated_at = create(:merchant, id: 50, updated_at: "2012-03-27 14:54:05 UTC").updated_at

    get "/api/v1/merchants/find?updated_at=#{updated_at}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    # expect(merchant["data"]["attributes"]["updated_at"]).to eq("2012-03-27T14:54:05.000Z")
    expect(merchant["data"]["attributes"]["id"]).to eq(50)
  end

  it 'can find all merchants with the same id' do
    id = create(:merchant).id

    get "/api/v1/merchants/find_all?id=#{id}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant.count).to eq(1)
    expect(merchant["data"].first["attributes"]["id"]).to eq(id)
  end

  it 'can find all merchants with the same name' do
    4.times do
      create(:merchant, name: "Williamson Group")
    end

    name = Merchant.first.name

    get "/api/v1/merchants/find_all?name=#{name}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"].count).to eq(4)
    expect(merchant["data"].first["attributes"]["name"]).to eq(name)
    expect(merchant["data"].last["attributes"]["name"]).to eq(name)
  end

  it 'can find all merchants with the same created at time' do
    3.times do
      create(:merchant, created_at: "2012-03-27 14:54:05 UTC")
    end

    created_at = Merchant.first.created_at

    get "/api/v1/merchants/find_all?created_at=#{created_at}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"].count).to eq(3)
    # expect(merchant["data"].first["created_at"]).to eq("2012-03-27T14:54:05.000Z")
    # expect(merchant["data"].last["created_at"]).to eq("2012-03-27T14:54:05.000Z")
  end

  it 'can find all merchants with the same updated at time' do
    5.times do
      create(:merchant, updated_at: "2012-03-27 14:59:09 UTC")
    end

    updated_at = Merchant.first.updated_at

    get "/api/v1/merchants/find_all?updated_at=#{updated_at}"

    merchant = JSON.parse(response.body)
    expect(response).to be_successful
    expect(merchant["data"].count).to eq(5)

    # expect(merchant["data"].first["updated_at"]).to eq("2012-03-27T14:59:09.000Z")
    # expect(merchant["data"].last["updated_at"]).to eq("2012-03-27T14:59:09.000Z")
  end

      # _______ RELATIONSHIP ENDPOINTS TESTS ________

  it 'can get a list of all the items for a merchant' do
    id = create(:merchant).id

    5.times do
      create(:item, merchant_id: id)
    end

    merchant_2 = create(:merchant)
    create(:item, merchant_id: merchant_2.id)

    get "/api/v1/merchants/#{id}/items"

    items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(items.count).to eq(5)
  end

  it 'can get a list of all of the invoices associated with a merchant' do
    merchant_id = create(:merchant).id
    customer_id  = create(:customer).id
    10.times do
      create(:invoice, customer_id: customer_id, merchant_id: merchant_id)
    end

    merchant_2_id = create(:merchant).id
    create(:invoice, customer_id: customer_id, merchant_id: merchant_2_id)

    get "/api/v1/merchants/#{merchant_id}/invoices"

    invoices = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoices.count).to eq(10)
  end

      # _______ BUSINESS INTELLIGENCE ENDPOINTS TESTS ________

  # describe 'business intelligence endpoints' do
  #   it 'returns the top x merchants ranked by total revenue' do
  #     customer_1 = create(:customer)
  #
  #     merchant_1 = create(:merchant)
  #     merchant_2 = create(:merchant)
  #     merchant_3 = create(:merchant)
  #     merchant_4 = create(:merchant)
  #     merchant_5 = create(:merchant)
  #
  #     item_1 = create(:item, merchant_id: merchant_1.id)
  #     item_2 = create(:item, merchant_id: merchant_2.id)
  #     item_3 = create(:item, merchant_id: merchant_3.id)
  #     item_4 = create(:item, merchant_id: merchant_4.id)
  #     item_5 = create(:item, merchant_id: merchant_5.id)
  #
  #     invoice_1 = create(:invoice, customer_id: customer_1.id, merchant_id: merchant_1.id)
  #     invoice_2 = create(:invoice, customer_id: customer_1.id, merchant_id: merchant_2.id)
  #     invoice_3 = create(:invoice, customer_id: customer_1.id, merchant_id: merchant_3.id)
  #     invoice_4 = create(:invoice, customer_id: customer_1.id, merchant_id: merchant_4.id)
  #     invoice_5 = create(:invoice, customer_id: customer_1.id, merchant_id: merchant_5.id)
  #
  #     invoice_item_1 = create(:invoice_item, quantity: 1, unit_price: 100, item_id: item_1.id, invoice_id: invoice_1.id)
  #     invoice_item_2 = create(:invoice_item, item_id: item_2.id, invoice_id: invoice_2.id)
  #     invoice_item_3 = create(:invoice_item, item_id: item_3.id, invoice_id: invoice_3.id)
  #     invoice_item_4 = create(:invoice_item, item_id: item_4.id, invoice_id: invoice_4.id)
  #     invoice_item_5 = create(:invoice_item, item_id: item_5.id, invoice_id: invoice_5.id)
  #
  #     transaction_1 = create(:transaction, invoice_id: invoice_1.id, result: "success")
  #     transaction_2 = create(:transaction, invoice_id: invoice_2.id, result: "success")
  #     transaction_3 = create(:transaction, invoice_id: invoice_3.id, result: "success")
  #     transaction_4 = create(:transaction, invoice_id: invoice_4.id, result: "success")
  #     transaction_5 = create(:transaction, invoice_id: invoice_5.id, result: "success")
  #
  #     get "/api/v1/merchants/most_revenue?quantity=5"
  #
  #     top_5 = JSON.parse(response.body)
  #
  #     expect(response).to be_successful
  #   end
  # end
end
