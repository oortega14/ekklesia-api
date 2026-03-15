# app/services/auth/errors.rb
module Auth
  module Errors
    class Base < StandardError; end
    class TokenExpired < Base; end
    class TokenInvalid < Base; end
    class Unauthorized < Base; end
  end
end
