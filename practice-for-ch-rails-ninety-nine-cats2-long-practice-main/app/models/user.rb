class User < ApplicationRecord
    after_initialize :ensure_session_token

    validates :username, uniqueness: true, presence: true

    validates :session_token, presence: true, uniqueness: true

    validates :password, length: {minimum: 6}, allow_nil: true

    

    def self.find_by_credentials(username,password)
        user = User.find_by(username: username)

        if user && user.is_password?(password)
            return user
        else
            return nil
        end
    end

    def password=(password)
        self.password_digest = BCrypt::Password.create(password)
        @password = password
    end

    def is_password?(password)
        password_object = BCrypt::Password.new(self.password_digest) # Checking the hash
        password_object.is_password?(password)
    end

   

    def reset_session_token!
        self.session_token = SecureRandom::urlsafe_base64
        self.save!
        self.session_token
    end

    private 

    def ensure_session_token
        self.session_token ||= SecureRandom::urlsafe_base64
    end

    attr_reader :password



end
