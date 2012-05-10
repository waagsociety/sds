module Exceptions
  class StoreError < StandardError; end
  class StoreAuthenticationError < StoreError; end
end
