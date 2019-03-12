require 'rails_helper'

describe "Merchants API" do
  it 'sends a list of merchants' do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful
    expect(Merchant.count).to eq(3)
  end

  it 'can get a merchant by its id' do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["id"]).to eq(id)
  end

  it 'can get a merchant by its name' do
    name = create(:merchant).name

    get "/api/v1/merchants/find?name=#{name}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["name"]).to eq(name)
  end

  it 'can get a merchant by its created at time' do
    created_at = create(:merchant, id: 60, created_at: "2012-03-27 14:54:05 UTC").created_at

    get "/api/v1/merchants/find?created_at=#{created_at}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["created_at"]).to eq("2012-03-27T14:54:05.000Z")
  end

  it 'can get a merchant by its updated at time' do
    updated_at = create(:merchant, id: 60, updated_at: "2012-03-27 14:54:05 UTC").updated_at

    get "/api/v1/merchants/find?updated_at=#{updated_at}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["updated_at"]).to eq("2012-03-27T14:54:05.000Z")
  end

  it 'can find all merchants with the same id' do
    id = create(:merchant).id

    get "/api/v1/merchants/find_all?id=#{id}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant.count).to eq(1)
    expect(merchant[0]["id"]).to eq(id)
  end

  it 'can find all merchants with the same name' do
    4.times do
      create(:merchant, name: "Williamson Group")
    end

    name = Merchant.first.name

    get "/api/v1/merchants/find_all?name=#{name}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant.count).to eq(4)
    expect(merchant.first["name"]).to eq(name)
    expect(merchant.last["name"]).to eq(name)
  end

  it 'can find all merchants with the same created at time' do
    3.times do
      create(:merchant, created_at: "2012-03-27 14:54:05 UTC")
    end

    created_at = Merchant.first.created_at

    get "/api/v1/merchants/find_all?created_at=#{created_at}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant.count).to eq(3)
    expect(merchant.first["created_at"]).to eq("2012-03-27T14:54:05.000Z")
    expect(merchant.last["created_at"]).to eq("2012-03-27T14:54:05.000Z")

  end

  it 'can find all merchants with the same updated at time' do
    5.times do
      create(:merchant, updated_at: "2012-03-27 14:59:09 UTC")
    end

    updated_at = Merchant.first.updated_at

    get "/api/v1/merchants/find_all?updated_at=#{updated_at}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant.count).to eq(5)
    expect(merchant.first["updated_at"]).to eq("2012-03-27T14:59:09.000Z")
    expect(merchant.last["updated_at"]).to eq("2012-03-27T14:59:09.000Z")
  end
end
