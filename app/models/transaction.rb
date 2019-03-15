class Transaction < ApplicationRecord
  belongs_to :invoice

  scope :successful, -> { where(result: "success") }

  default_scope { order(:id) }
end
