class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :promotions
  has_many :promotion_approvals
  validates :email, email: true
end
