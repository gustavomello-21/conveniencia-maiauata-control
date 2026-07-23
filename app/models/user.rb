class User < ApplicationRecord
  has_secure_password
  has_many :sales

  enum :role, { vendedor: 0, admin: 1 }

  validates :email, presence: true, uniqueness: true
end
