class Comment < ApplicationRecord
  belongs_to :team_member
  belongs_to :task
end
