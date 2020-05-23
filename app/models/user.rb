
class User < ApplicationRecord
	attr_accessor :remember_token, :activation_token

	before_save :downcase_email
	before_create :create_activation_digest

	# presence check co du lieu hay khong
	# message dinh nghia thong bao lois
	validates :name, presence: true,length: {maximum: 50 , message: "max is 50"}


	#custom validate
	# validates : check_length_name ,if: ->{name.presence?}
	# def check_length_name
	# 	if name.size > 150 
	# 		errors.add :name ,"Max is 150"
	# 	end
		
	# end
	validates :password, presence: true,length: {minimum: 6},allow_nil: true
	before_save { email.downcase! }
  	
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	#uniqueness mac dinh setting khong phan biet hoa thuong 
	# uniqueness : {}
	validates :email, presence: true,length: {maximum: 255},format: {with:VALID_EMAIL_REGEX}, uniqueness: true
	
	has_secure_password
  	validates :password,presence: true, length: { minimum: 6 }

  	def User.digest string
 		cost = if ActiveModel::SecurePassword.min_cost
    		BCrypt::Engine::MIN_COST
 				else
  			BCrypt::Engine.cost
				end
			BCrypt::Password.create string, cost: cost
	end

	class << self
		def new_token
			SecureRandom.urlsafe_base64
		end
	end

	def remember
		self.remember_token = User.new_token
		update_attribute :remember_digest, User.digest(remember_token)
	end

	def authenticated? 
		remember_token BCrypt::Password.new(remember_digest).is_password? remember_token
	end

	def forget
  		update_attribute :remember_digest, nil
	end

	def activate
		update_attributes :activated, true 
		update_attributes :activated_at, Time.zone.now
	end

	def send_activation_email 
		UserMailer.account_activation(self).deliver_now
	end

	private 

	def downcase_email
		self.email.downcase!
	end

	def create_activation_digest
		self.activation_token =User.new_token
		self.activation_digest = User.digest(activation_token)
	end

	def authenticated? attribute, token
		digest = send "#{attribute}_digest"
		return false if digest.nil?
		BCrypt::Password.new(digest).is_password? token
	end
end
