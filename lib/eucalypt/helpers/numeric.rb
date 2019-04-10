module Eucalypt
  module Helpers
    module Numeric
      def self.string?(string)
        return true if /\A\d+\Z/.match? string
        true if Float(string) rescue false
      end
    end
  end
end