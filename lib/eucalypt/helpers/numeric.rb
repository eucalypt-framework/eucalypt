module Eucalypt
  module Helpers
    module Numeric
      def self.string?(string)
        return true if /\A\d+\Z/.match? string.to_s
        true if Float(string.to_s) rescue false
      end
    end
  end
end