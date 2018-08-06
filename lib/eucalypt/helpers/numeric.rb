module Eucalypt
  module Helpers
    module Numeric
      def self.string?(string)
        return true if string =~ /\A\d+\Z/
        true if Float(string) rescue false
      end
    end
  end
end