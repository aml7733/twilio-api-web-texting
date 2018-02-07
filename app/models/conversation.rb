class Conversation < ApplicationRecord
  has_many :messages
  validates :phone_number, presence: true, uniqueness: true
end
