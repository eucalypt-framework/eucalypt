module Eucalypt
  VERSION = {
    major: 0,
    minor: 6,
    patch: 2,
    meta: nil
  }.values.reject(&:nil?).map(&:to_s)*?.
end