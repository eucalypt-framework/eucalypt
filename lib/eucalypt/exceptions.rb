module Eucalypt
  class NotWhitelistedError < Exception
    def initialize(ip)
      super "IP address #{ip} not whitelisted"
    end
  end
  class InvalidSettingTypeError < Exception
    def initialize(setting, actual, classes)
      super "!\nInvalid type for setting :#{setting}, got:\n\t#{actual},\nmust be one of:\n\t#{classes}"
    end
  end
end