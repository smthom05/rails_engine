require 'rails_helper'

describe "Invoices API" do
  it 'sends a list of invoices' do
    create_list(:invoice, 5)

    get '/api/v1/invoices'

    expect(response).to be_successful
    expect(Invoice.count).to eq(5)
  end

  it 'can get an invoice by its id' do
    id = create(:invoice).id

    get "/api/v1/invoices/#{id}"

    invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice["data"]["attributes"]["id"]).to eq(id)
  end

  it 'can find first instance by its customer id' do
    customer = create(:customer, id: 5)
    invoice_1 = create(:invoice, id: 2, customer_id: customer.id)
    invoice_2 = create(:invoice, id: 100, customer_id: customer.id)

    get "/api/v1/invoices/find?customer_id=#{customer.id}"

    invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice["data"]["attributes"]["id"]).to eq(invoice_1.id)
    expect(invoice["data"]["attributes"]["id"]).to_not eq(invoice_2.id)
  end

  it 'can find first instance by its merchant id' do
    merchant = create(:merchant, id: 5)
    invoice_1 = create(:invoice, id: 2, merchant_id: merchant.id)
    invoice_2 = create(:invoice, id: 100, merchant_id: merchant.id)

    get "/api/v1/invoices/find?merchant_id=#{merchant.id}"

    invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice["data"]["attributes"]["id"]).to eq(invoice_1.id)
    expect(invoice["data"]["attributes"]["id"]).to_not eq(invoice_2.id)
  end

  it 'can find first instance by status' do
    status = create(:invoice, id: 55, status: "shipped").status
    create_list(:invoice, 3, status: "shipped")

    get "/api/v1/invoices/find?status=#{status}"

    invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice["data"]["attributes"]["status"]).to eq(status)
    expect(invoice["data"]["attributes"]["id"]).to eq(55)
  end

  it 'can find first instance by created at time' do
    created_at = create(:invoice, id: 60, created_at: "2012-03-27 14:54:05 UTC").created_at

    get "/api/v1/invoices/find?created_at=#{created_at}"

    invoice = JSON.parse(response.body)

    expect(response).to be_successful
    # expect(merchant["data"]["attributes"]["created_at"]).to eq("2012-03-27T14:54:05.000Z")
    expect(invoice["data"]["attributes"]["id"]).to eq(60)
  end

  it 'can find first instance by updated at time' do
    updated_at = create(:invoice, id: 60, updated_at: "2012-03-27 14:54:05 UTC").updated_at

    get "/api/v1/invoices/find?updated_at=#{updated_at}"

    invoice = JSON.parse(response.body)

    expect(response).to be_successful
    # expect(merchant["data"]["attributes"]["created_at"]).to eq("2012-03-27T14:54:05.000Z")
    expect(invoice["data"]["attributes"]["id"]).to eq(60)
  end


  it 'can find all invoices with a customer id' do
    id = create(:customer, id: 5).id
     4.times do
      create(:invoice, customer_id: id)
    end

    get "/api/v1/invoices/find_all?customer_id=#{id}"

    invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice["data"].count).to eq(4)
    expect(invoice["data"].first["attributes"]["customer_id"]).to eq(id)
    expect(invoice["data"].last["attributes"]["customer_id"]).to eq(id)
  end

  it 'can find all invoices with a merchant id' do
    id = create(:merchant, id: 10).id
     5.times do
      create(:invoice, merchant_id: id)
    end

    get "/api/v1/invoices/find_all?merchant_id=#{id}"

    invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice["data"].count).to eq(5)
    expect(invoice["data"].first["attributes"]["merchant_id"]).to eq(id)
    expect(invoice["data"].last["attributes"]["merchant_id"]).to eq(id)
  end

  it 'can find all invoices with the same created at time' do
    3.times do
      create(:invoice, created_at: "2012-03-27 14:54:05 UTC")
    end

    created_at = Invoice.first.created_at

    get "/api/v1/invoices/find_all?created_at=#{created_at}"

    invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice["data"].count).to eq(3)
    # expect(invoice["data"].first["created_at"]).to eq("2012-03-27T14:54:05.000Z")
    # expect(invoice["data"].last["created_at"]).to eq("2012-03-27T14:54:05.000Z")
  end

  it 'can find all invoices with the same updated at time' do
    5.times do
      create(:invoice, updated_at: "2012-03-27 14:59:09 UTC")
    end

    updated_at = Invoice.first.updated_at

    get "/api/v1/invoices/find_all?updated_at=#{updated_at}"

    invoice = JSON.parse(response.body)
    expect(response).to be_successful
    expect(invoice["data"].count).to eq(5)
  end

  # _______ RELATIONSHIP ENDPOINTS TESTS ________

  it 'can get a list of items associated with an invoice' do
    id = create(:invoice).id
    merchant_id = create(:merchant).id
    item = create(:item, merchant_id: merchant_id)

    4.times do
      create(:invoice_item, item_id: item.id, invoice_id: id)
    end

    get "/api/v1/invoices/#{id}/items"

    items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(items.count).to eq(4)
  end
end
