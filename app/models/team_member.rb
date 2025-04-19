class TeamMember < ApplicationRecord
  belongs_to :user
  belongs_to :team
  has_many :tasks
end
