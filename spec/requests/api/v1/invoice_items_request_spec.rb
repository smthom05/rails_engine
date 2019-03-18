require 'rails_helper'

describe "InvoiceItems API" do
  it 'returns all invoice items' do
    create_list(:invoice_item, 11)

    get "/api/v1/invoice_items"

    invoice_item = JSON.parse(response.body)["data"]

    expect(response).to be_successful
    expect(invoice_item.count).to eq(11)
  end

  it 'can get an invoice item by its id' do
    id = create(:invoice_item).id

    get "/api/v1/invoice_items/#{id}"

    invoice_item = JSON.parse(response.body)["data"]

    expect(response).to be_successful
    expect(invoice_item["attributes"]["id"]).to eq(id)
  end

  it 'can get the first instance of invoice item by its id' do
    id = create(:invoice_item).id

    get "/api/v1/invoice_items/find?id=#{id}"

    invoice_item = JSON.parse(response.body)["data"]

    expect(response).to be_successful
    expect(invoice_item["attributes"]["id"]).to eq(id)

  end

  it 'can get the first instance of invoice by item id' do
    item_id = create(:item).id
    invoice_item_id = create(:invoice_item, item_id: item_id).id

    get "/api/v1/invoice_items/find?item_id=#{item_id}"

    invoice_item = JSON.parse(response.body)["data"]

    expect(response).to be_successful
    expect(invoice_item["attributes"]["id"]).to eq(invoice_item_id)
  end

  it 'can get the first instance of invoice by invoice id' do
    invoice_id = create(:invoice).id
    invoice_item_id = create(:invoice_item, invoice_id: invoice_id).id

    get "/api/v1/invoice_items/find?invoice_id=#{invoice_id}"

    invoice_item = JSON.parse(response.body)["data"]

    expect(response).to be_successful
    expect(invoice_item["attributes"]["invoice_id"]).to eq(invoice_id)
  end

  it 'can get the first instance of invoice by quantity' do
    quantity = create(:invoice_item).quantity

    get "/api/v1/invoice_items/find?quantity=#{quantity}"

    invoice_item = JSON.parse(response.body)["data"]

    expect(response).to be_successful
    expect(invoice_item["attributes"]["quantity"]).to eq(quantity)
  end

    it 'can get the first instance of invoice by unit_price' do
      unit_price = create(:invoice_item).unit_price

      get "/api/v1/invoice_items/find?unit_price=#{unit_price}"

      invoice_item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice_item["attributes"]["unit_price"]).to eq(unit_price)
    end

    it 'can get first instance of invoice_item by its created at time' do
      created_at = create(:invoice_item, id: 60, created_at: "2012-03-27 14:54:05 UTC").created_at

      get "/api/v1/invoice_items/find?created_at=#{created_at}"

      invoice_item = JSON.parse(response.body)

      expect(response).to be_successful
      # expect(invoice_item["data"]["attributes"]["created_at"]).to eq("2012-03-27T14:54:05.000Z")
      expect(invoice_item["data"]["attributes"]["id"]).to eq(60)
    end

    it 'can get first instance of invoice_item by its updated at time' do
      updated_at = create(:invoice_item, id: 60, updated_at: "2012-03-27 14:54:05 UTC").updated_at

      get "/api/v1/invoice_items/find?updated_at=#{updated_at}"

      invoice_item = JSON.parse(response.body)

      expect(response).to be_successful
      # expect(invoice_item["data"]["attributes"]["updated_at"]).to eq("2012-03-27T14:54:05.000Z")
      expect(invoice_item["data"]["attributes"]["id"]).to eq(60)
    end


    # Finders

    it "it can find all instances of invoice items by id" do
      id = create(:invoice_item).id

      get "/api/v1/invoice_items/find_all?id=#{id}"

      invoice_item = JSON.parse(response.body)["data"]
      expect(response).to be_successful
      expect(invoice_item.first["attributes"]["id"]).to eq(id)
    end

    it "it can find all instances of invoice items by item id" do
      item_id = create(:item).id

      5.times do
        create(:invoice_item, item_id: item_id)
      end

      get "/api/v1/invoice_items/find_all?item_id=#{item_id}"

      invoice_items = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice_items.count).to eq(5)
      expect(invoice_items.first["attributes"]["item_id"]).to eq(item_id)
      expect(invoice_items.last["attributes"]["item_id"]).to eq(item_id)
    end

end
