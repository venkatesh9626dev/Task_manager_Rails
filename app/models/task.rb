class Task < ApplicationRecord
  belongs_to :team_member
  belongs_to :team
  has_many :comments
end
