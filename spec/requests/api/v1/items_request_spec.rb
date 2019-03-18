require 'rails_helper'

describe "Items API" do
  it 'sends a list of all items' do
    create_list(:item, 10)

    get "/api/v1/items"

    items = JSON.parse(response.body)["data"]

    expect(response).to be_successful
    expect(items.count).to eq(10)
  end

  it 'can get an item by its id' do
    id = create(:item).id

    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["data"]["attributes"]["id"]).to eq(id)
  end

  # Finder Tests

  it 'returns the first instance of item by id' do
    id = create(:item).id

    get "/api/v1/items/find?id=#{id}"

    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["data"]["attributes"]["id"]).to eq(id)
  end

  it 'finds the first instance of item by name' do
    name = create(:item).name

    get "/api/v1/items/find?name=#{name}"

    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["data"]["attributes"]["name"]).to eq(name)
  end

  it 'finds the first instance of item by its description' do
    description = create(:item).description

    get "/api/v1/items/find?description=#{description}"

    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["data"]["attributes"]["description"]).to eq(description)
  end

  it 'finds the first instance of item by its unit price' do
    unit_price = create(:item).unit_price

    get "/api/v1/items/find?unit_price=#{unit_price}"

    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["data"]["attributes"]["unit_price"]).to eq(unit_price)
  end

  it 'can get a item by its created at time' do
    created_at = create(:item, id: 60, created_at: "2012-03-27 14:54:05 UTC").created_at

    get "/api/v1/items/find?created_at=#{created_at}"

    item = JSON.parse(response.body)

    expect(response).to be_successful
    # expect(item["data"]["attributes"]["created_at"]).to eq("2012-03-27T14:54:05.000Z")
    expect(item["data"]["attributes"]["id"]).to eq(60)
  end

  it 'can get a item by its updated at time' do
    updated_at = create(:item, id: 60, updated_at: "2012-03-27 14:54:05 UTC").updated_at

    get "/api/v1/items/find?updated_at=#{updated_at}"

    item = JSON.parse(response.body)

    expect(response).to be_successful
    # expect(item["data"]["attributes"]["created_at"]).to eq("2012-03-27T14:54:05.000Z")
    expect(item["data"]["attributes"]["id"]).to eq(60)
  end


# Finders

  it 'can get all instances by id' do
    id = create(:item).id

    get "/api/v1/items/find_all?id=#{id}"

    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item.count).to eq(1)
    expect(item["data"].first["attributes"]["id"]).to eq(id)
  end

  it 'can find all instances by"name' do
    name = create(:item).name

    4.times do
      create(:item, name: name)
    end

    get "/api/v1/items/find_all?name=#{name}"

    items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(items["data"].count).to eq(5)
    expect(items["data"].first["attributes"]["name"]).to eq(name)
    expect(items["data"].last["attributes"]["name"]).to eq(name)
  end

  it 'can find all instances by description' do
    description = create(:item).description

    4.times do
      create(:item, description: description)
    end

    get "/api/v1/items/find_all?description=#{description}"

    items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(items["data"].count).to eq(5)
    expect(items["data"].first["attributes"]["description"]).to eq(description)
    expect(items["data"].last["attributes"]["description"]).to eq(description)
  end

  it 'can find all instances by unit price' do
    unit_price = create(:item).unit_price

    4.times do
      create(:item, unit_price: unit_price)
    end

    get "/api/v1/items/find_all?unit_price=#{unit_price}"

    items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(items["data"].count).to eq(5)
    expect(items["data"].first["attributes"]["unit_price"]).to eq(unit_price)
    expect(items["data"].last["attributes"]["unit_price"]).to eq(unit_price)
  end

  it 'can find all instances by merchant id' do
    merchant_id = create(:merchant).id

    4.times do
      create(:item, merchant_id: merchant_id)
    end

    get "/api/v1/items/find_all?merchant_id=#{merchant_id}"

    items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(items["data"].count).to eq(4)
    expect(items["data"].first["attributes"]["merchant_id"]).to eq(merchant_id)
    expect(items["data"].last["attributes"]["merchant_id"]).to eq(merchant_id)
  end

  it 'can find all instances by created at time' do
    created_at = create(:item).created_at

    4.times do
      create(:item, created_at: created_at)
    end

    get "/api/v1/items/find_all?created_at=#{created_at}"

    items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(items["data"].count).to eq(5)
  end

  it 'can find all instances by updated at time' do
    updated_at = create(:item).updated_at

    4.times do
      create(:item, updated_at: updated_at)
    end

    get "/api/v1/items/find_all?updated_at=#{updated_at}"

    items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(items["data"].count).to eq(5)
  end

  # _______ RELATIONSHIP ENDPOINTS TESTS ________

  it 'can return all invoice items associated with an item' do
    id = create(:item).id

    5.times do
      create(:invoice_item, item_id: id)
    end

    get "/api/v1/items/#{id}/invoice_items"
    invoice_items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_items["data"].count).to eq(5)
    expect(invoice_items["data"].first["attributes"]["item_id"]).to eq(id)
    expect(invoice_items["data"].last["attributes"]["item_id"]).to eq(id)
  end

  it 'can return the merchant associated with that item' do
    merchant_id = create(:merchant).id
    id = create(:item, merchant_id: merchant_id).id

    get "/api/v1/items/#{id}/merchant"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant.count).to eq(1)
    expect(merchant["data"]["attributes"]["id"]).to eq(merchant_id)
  end
end
