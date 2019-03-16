require 'rails_helper'

describe "Transactions API" do
  it 'sends a list of all transactions' do
    create_list(:transaction, 5)

    get '/api/v1/transactions'

    transaction = JSON.parse(response.body)["data"]
    
    expect(response).to be_successful
    expect(transaction.count). to eq(5)
  end

  it 'can get an instance of transaction by id' do
    id = create(:transaction).id

    get "/api/v1/transactions/#{id}"

    transaction = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transaction["data"]["attributes"]["id"]).to eq(id)
  end

  it 'can get the first instance of transaction by its id' do
    id = create(:transaction).id

    get "/api/v1/transactions/find?id=#{id}"

    transaction = JSON.parse(response.body)
    expect(response).to be_successful
    expect(transaction["data"]["attributes"]["id"]).to eq(id)
  end

  it 'can get the first instance of transaction by its invoice id' do
    invoice_id = create(:invoice).id
    transaction_1 = create(:transaction, invoice_id: invoice_id)

    get "/api/v1/transactions/find?invoice_id=#{invoice_id}"

    transaction = JSON.parse(response.body)
    expect(response).to be_successful
    expect(transaction["data"]["attributes"]["id"]).to eq(transaction_1.id)
  end

  it 'can get the first instance of transaction by its credit card number' do
    ccn = create(:transaction).credit_card_number

    get "/api/v1/transactions/find?credit_card_number=#{ccn}"

    transaction = JSON.parse(response.body)
    expect(response).to be_successful
    expect(transaction["data"]["attributes"]["credit_card_number"]).to eq(ccn)
  end

  it 'can get the first instance of transaction by its credit card expiration' do
    cced = create(:transaction).credit_card_expiration_date

    get "/api/v1/transactions/find?credit_card_number=#{cced}"

    transaction = JSON.parse(response.body)
    expect(response).to be_successful
    expect(transaction["data"]["attributes"]["credit_card_expiration_date"]).to eq(cced)
  end

  it 'can get the first instance of transaction by result' do
    result = create(:transaction, id: 5).result

    get "/api/v1/transactions/find?result=#{result}"

    transaction = JSON.parse(response.body)
    expect(response).to be_successful
    expect(transaction["data"]["attributes"]["id"]).to eq(5)
    expect(transaction["data"]["attributes"]["result"]).to eq(result)
  end

  it 'can get first instance of transaction by its created at time' do
    created_at = create(:transaction, id: 60, created_at: "2012-03-27 14:54:05 UTC").created_at

    get "/api/v1/transactions/find?created_at=#{created_at}"

    transaction = JSON.parse(response.body)

    expect(response).to be_successful
    # expect(transaction["data"]["attributes"]["created_at"]).to eq("2012-03-27T14:54:05.000Z")
    expect(transaction["data"]["attributes"]["id"]).to eq(60)
  end

  it 'can get first instance of transaction by its updated at time' do
    updated_at = create(:transaction, id: 60, updated_at: "2012-03-27 14:54:05 UTC").updated_at

    get "/api/v1/transactions/find?updated_at=#{updated_at}"

    transaction = JSON.parse(response.body)

    expect(response).to be_successful
    # expect(transaction["data"]["attributes"]["updated_at"]).to eq("2012-03-27T14:54:05.000Z")
    expect(transaction["data"]["attributes"]["id"]).to eq(60)
  end

  #Finders

  it 'can get all instances by id' do
    id = create(:transaction).id

    get "/api/v1/transactions/find_all?id=#{id}"

    transaction = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transaction.count).to eq(1)
    expect(transaction["data"].first["attributes"]["id"]).to eq(id)
  end

  it 'can find all instances by invoice id' do
    invoice_id = create(:invoice).id

    4.times do
      create(:transaction, invoice_id: invoice_id)
    end

    get "/api/v1/transactions/find_all?invoice_id=#{invoice_id}"

    transactions = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transactions["data"].count).to eq(4)
    expect(transactions["data"].first["attributes"]["invoice_id"]).to eq(invoice_id)
    expect(transactions["data"].last["attributes"]["invoice_id"]).to eq(invoice_id)
  end

  it 'can find all instances by credit card number' do
    ccn = create(:transaction).credit_card_number

    4.times do
      create(:transaction, credit_card_number: ccn)
    end

    get "/api/v1/transactions/find_all?credit_card_number=#{ccn}"

    transactions = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transactions["data"].count).to eq(5)
    expect(transactions["data"].first["attributes"]["credit_card_number"]).to eq(ccn)
    expect(transactions["data"].last["attributes"]["credit_card_number"]).to eq(ccn)
  end

  it 'can find all instances by credit card expiration date' do
    cced = create(:transaction).credit_card_expiration_date

    4.times do
      create(:transaction, credit_card_expiration_date: cced)
    end

    get "/api/v1/transactions/find_all?credit_card_expiration_date=#{cced}"

    transactions = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transactions["data"].count).to eq(5)
    expect(transactions["data"].first["attributes"]["credit_card_expiration_date"]).to eq(cced)
    expect(transactions["data"].last["attributes"]["credit_card_expiration_date"]).to eq(cced)
  end

  it 'can find all instances by result' do
    result = create(:transaction).result

    4.times do
      create(:transaction, result: result)
    end

    get "/api/v1/transactions/find_all?result=#{result}"

    transactions = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transactions["data"].count).to eq(5)
    expect(transactions["data"].first["attributes"]["result"]).to eq(result)
    expect(transactions["data"].last["attributes"]["result"]).to eq(result)
  end

  it 'can find all instances by created at time' do
    created_at = create(:transaction).created_at

    4.times do
      create(:transaction, created_at: created_at)
    end

    get "/api/v1/transactions/find_all?created_at=#{created_at}"

    transactions = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transactions["data"].count).to eq(5)
  end

  it 'can find all instances by updated at time' do
    updated_at = create(:transaction).updated_at

    4.times do
      create(:transaction, updated_at: updated_at)
    end

    get "/api/v1/transactions/find_all?updated_at=#{updated_at}"

    transactions = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transactions["data"].count).to eq(5)
  end

  # _______ RELATIONSHIP ENDPOINTS TESTS ________

  it 'returns the invoice associated with a transaction' do
    invoice_id = create(:invoice).id
    id = create(:transaction, invoice_id: invoice_id).id

    get "/api/v1/transactions/#{id}/invoice"

    invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice["data"]["attributes"]["id"]).to eq(invoice_id)
    expect(invoice.count).to eq(1)
  end

end
