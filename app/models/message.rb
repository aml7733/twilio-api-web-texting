class Message < ApplicationRecord
  validates :name, :phone_number, :text, presence: true
end
