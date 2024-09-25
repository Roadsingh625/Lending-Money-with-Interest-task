# app/models/user.rb
class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  
  has_one :wallet, dependent: :destroy
  has_many :loans
  after_create :create_wallet

  private

  def create_wallet
    Wallet.create(user: self, balance: admin? ? 10_00_000 : 10_000)
  end
end
