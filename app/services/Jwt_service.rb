class JwtService
  HMAC_SECRET = ENV["JWT_SECRET_KEY"]

  def self.encode(payload)
    payload[:exp] = 24.hours.from_now.to_i  # Set an expiration time for the token
    JWT.encode(payload, HMAC_SECRET)
  end

  def self.decode(token)
    puts "Decoding with secret: #{HMAC_SECRET}"  # Debugging statement
    body = JWT.decode(token, HMAC_SECRET).first
    HashWithIndifferentAccess.new(body)  # Return the decoded payload as a Hash
  end
end