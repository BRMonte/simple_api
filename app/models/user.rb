class User < ApplicationRecord
  acts_as_token_authenticatable
  has_many :reviews

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def generate_new_authentication_token
    token = User.generate_unique_secure_token
    update_attributes(authentication_token: token)
  end
end
