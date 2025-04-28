class User < ApplicationRecord



    has_many :teams, dependent: :destroy
    has_many :team_members, dependent: :destroy
    has_many :notifications, dependent: :destroy
    has_secure_password

    validates :username, presence: true, uniqueness: true, length: {minimum:3, maximum:30}
    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :password, presence: true, length: { minimum: 6 }
    validates :role, inclusion: {in: UsersEnum::RolesEnum::ROLES}
end
