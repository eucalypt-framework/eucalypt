module Eucalypt
  VERSION = {
    major: 0,
    minor: 7,
    patch: 0,
    meta: nil
  }.values.reject(&:nil?).map(&:to_s)*?.
end