require 'rails_helper'

describe 'Customers API' do
  it 'sends a list of customers' do
    create_list(:customer, 5)

    get '/api/v1/customers'

    expect(response).to be_successful
    expect(Customer.count).to eq(5)
  end

  it 'can get a customer by its id' do
    id = create(:customer).id

    get "/api/v1/customers/#{id}"

    customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer["data"]["attributes"]['id']).to eq(id)
  end

  it 'can get the first customer by its first name' do
    customer_1 = create(:customer, id: 1, first_name: "Scott")
    customer_2 = create(:customer, id: 2, first_name: "Scott")

    get "/api/v1/customers/find?first_name=#{customer_1.first_name}"

    customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer["data"]["attributes"]["first_name"]).to eq(customer_1.first_name)
    expect(customer["data"]["attributes"]['id']).to eq(customer_1.id)
    expect(customer["data"]["attributes"]['id']).to_not eq(customer_2.id)
  end

  it 'can get the first customer by its last name' do
    customer_1 = create(:customer, id: 1, last_name: "Scott")
    customer_2 = create(:customer, id: 2, last_name: "Scott")

    get "/api/v1/customers/find?last_name=#{customer_1.last_name}"

    customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer["data"]["attributes"]["last_name"]).to eq(customer_1.last_name)
    expect(customer["data"]["attributes"]['id']).to eq(customer_1.id)
    expect(customer["data"]["attributes"]['id']).to_not eq(customer_2.id)
  end

  it 'can get a customer by its created at time' do
    created_at = create(:customer, id: 60, created_at: "2012-03-27 14:54:05 UTC").created_at

    get "/api/v1/customers/find?created_at=#{created_at}"

    customer = JSON.parse(response.body)
    expect(response).to be_successful
    # expect(customer["data"]["attributes"]["created_at"]).to eq("2012-03-27T14:54:05.000Z")
    expect(customer["data"]["attributes"]["id"]).to eq(60)
  end

  it 'can get a customer by its updated at time' do
    updated_at = create(:customer, id: 60, updated_at: "2012-03-27 14:54:05 UTC").updated_at

    get "/api/v1/customers/find?updated_at=#{updated_at}"

    customer = JSON.parse(response.body)
    expect(response).to be_successful
    # expect(customer["data"]["attributes"]["updated_at"]).to eq("2012-03-27T14:54:05.000Z")
    expect(customer["data"]["attributes"]["id"]).to eq(60)
  end

  it 'can find all customers with the same first name' do
    4.times do
      create(:customer, first_name: "Scott")
    end

    first_name = Customer.first.first_name

    get "/api/v1/customers/find_all?first_name=#{first_name}"

    customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer["data"].count).to eq(4)
    expect(customer["data"].first["attributes"]["first_name"]).to eq(first_name)
    expect(customer["data"].last["attributes"]["first_name"]).to eq(first_name)
  end

  it 'can find all customers with the same last name' do
    5.times do
      create(:customer, last_name: "Thomas")
    end

    last_name = Customer.first.last_name

    get "/api/v1/customers/find_all?last_name=#{last_name}"

    customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer["data"].count).to eq(5)
    expect(customer["data"].first["attributes"]["last_name"]).to eq(last_name)
    expect(customer["data"].last["attributes"]["last_name"]).to eq(last_name)
  end

  it 'can find all customers with the same created at time' do
    3.times do
      create(:customer, created_at: "2012-03-27 14:54:05 UTC")
    end

    created_at = Customer.first.created_at

    get "/api/v1/customers/find_all?created_at=#{created_at}"

    customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer["data"].count).to eq(3)
    # expect(merchant["data"].first["created_at"]).to eq("2012-03-27T14:54:05.000Z")
    # expect(merchant["data"].last["created_at"]).to eq("2012-03-27T14:54:05.000Z")
  end

  it 'can find all customers with the same updated at time' do
    5.times do
      create(:customer, updated_at: "2012-03-27 14:54:05 UTC")
    end

    updated_at = Customer.first.updated_at

    get "/api/v1/customers/find_all?updated_at=#{updated_at}"

    customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer["data"].count).to eq(5)
    # expect(merchant["data"].first["created_at"]).to eq("2012-03-27T14:54:05.000Z")
    # expect(merchant["data"].last["created_at"]).to eq("2012-03-27T14:54:05.000Z")
  end

  # _______ RELATIONSHIP ENDPOINTS TESTS ________

  it 'can get a list of all the invoices for a customer' do
    id = create(:customer).id
    merchant_id = create(:merchant).id

    5.times do
      create(:invoice, customer_id: id, merchant_id: merchant_id)
    end

    customer_6 = create(:customer)
    create(:invoice, customer_id: customer_6.id, merchant_id: merchant_id)

    get "/api/v1/customers/#{id}/invoices"

    invoices = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoices.count).to eq(5)
  end

  it 'can get a list of all the transactions for a customer' do
    id = create(:customer).id
    merchant_id = create(:merchant).id
    invoice_id = create(:invoice, customer_id: id, merchant_id: merchant_id).id

    5.times do
      create(:transaction, invoice_id: invoice_id)
    end

    customer_2 = create(:customer)
    invoice_2 = create(:invoice, customer_id: customer_2.id, merchant_id: merchant_id)
    create(:transaction, invoice_id: invoice_2.id)

    get "/api/v1/customers/#{id}/transactions"

    transactions = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transactions.count).to eq(5)
  end
end
