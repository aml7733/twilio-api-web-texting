class Message < ApplicationRecord
  belongs_to :conversation
  validates :name, :phone_number, :text, presence: true
end
