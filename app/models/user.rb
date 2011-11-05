class User < ActiveRecord::Base
  require 'digest'
  
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation
  has_many :microposts,  :dependent => :destroy
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
   
  validates :name,      :presence => true,
                        :length => {:maximum => 50}
  validates :email,     :presence => true,
                        :format => {:with => email_regex },
                        :uniqueness => {:case_sensitive => false}
  validates :password,  :presence => true,
                        :confirmation => true,
                        :length => {:within => 6..20 }
  before_save :encrypt_password
  
  
  def has_password?(submitted_password)
  if scramble(submitted_password) == self.encrypted_password
    then true
    else false
    end  
  end
  
  def self.authenticate(email, submitted_password)
  user = User.find_by_email(email)
  if !user.nil?
    then if user.has_password?(submitted_password)
            then return user
            else return nil
            end
    else return nil
  end
end

  def self.authenticate_with_salt(token_id, token_salt)
    user = User.find_by_id(token_id)
    (user && user.salt == token_salt ) ? user : nil
  end
  
  def feed
    Micropost.where("user_id = ?", self.id)  
  end
   
   private
  def encrypt_password
    self.salt = make_salt unless self.has_password?(self.password)
    self.encrypted_password = scramble(self.password)
  end
  
  def scramble(pass)
    secure_hash("#{self.salt}--#{pass}")
  end
  def make_salt
    secure_hash("#{Time.now.utc}--#{password}")
  end
  
  def secure_hash(string)
      Digest::SHA2.hexdigest(string)
  end
end
