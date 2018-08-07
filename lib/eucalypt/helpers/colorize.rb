module Eucalypt
  module Helpers
    module Colorize
      ANSI = {
        bold: '1',
        red: '91',
        yellow: '93',
        blue: '94',
        magenta: '95',
        pale_blue: '34',
        underline: '4',
        grey: '90'
      }

      def colorize(*opts)
        "\e[#{opts.map{|o| ANSI[o]}*?;}m#{self}\e[0m"
      end
    end
  end
end

String.include(Eucalypt::Helpers::Colorize)