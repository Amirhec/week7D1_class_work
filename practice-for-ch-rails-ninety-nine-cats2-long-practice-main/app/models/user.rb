class User < ApplicationRecord
    after_initialize :ensure_session_token

    validates :username, uniqueness: true, presence: true

    validates :session_token, presence: true, uniqueness: true

    validate :password, length: {minimum: 6}, allow_nil: true

    attr_reader :password

    def self.find_by_credentials(username,password)
        user = User.find_by(username: username)

        if user && user.is_password?(password)
            return user
        else
            return nil
        end
    end
    
end
