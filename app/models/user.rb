require 'digest/sha1'
require 'digest/sha2'

class User < ActiveRecord::Base
	set_primary_key :user_id
  cattr_accessor :current_user                                                  

  require "yaml"
  establish_connection(YAML.load_file("config/database.yml")['openmrs'] )


  def self.check_authenticity(password, username)
    user = User.find_by_username(username)
    if !user.blank?
      if user.password == user.verify_password(password, user.salt)
        return user
      end
    end
    return nil
  end

  def verify_password(in_password, in_salt)
    new_salt = salt = Digest::SHA1.hexdigest(in_password + in_salt)
  end


end
