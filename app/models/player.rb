class Player < ApplicationRecord
  has_many :won_matches, class_name: "Match", foreign_key: "winner_id", dependent: :destroy
  has_many :lost_matches, class_name: "Match", foreign_key: "winner_id", dependent: :destroy
end
