class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :promotions
  has_many :promotion_approvals
  has_many :approved_promotion, through: :promotion_approval, source: :promotion
  validates :email, email: true
  validates :name, presence: true
end
