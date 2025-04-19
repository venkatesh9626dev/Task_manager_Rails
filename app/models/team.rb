class Team < ApplicationRecord
    belongs_to :user
    has_many :tasks
    has_many :team_members
end
