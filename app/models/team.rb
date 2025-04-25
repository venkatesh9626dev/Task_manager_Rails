class Team < ApplicationRecord
    belongs_to :user
    has_many :tasks, dependent: :destroy
    has_many :team_members, dependent: :destroy
end
