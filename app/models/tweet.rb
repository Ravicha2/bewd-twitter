class Tweet < ApplicationRecord
    belongs_to :user
    validates :message, presence: true, length: { minimum: 0, maximum: 140 }
end
