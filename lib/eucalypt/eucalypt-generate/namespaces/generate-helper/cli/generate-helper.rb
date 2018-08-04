require 'eucalypt/eucalypt-generate/namespaces/generate-helper/generators/helper'
require 'eucalypt/errors'

module Eucalypt
  class Generate < Thor
    option :spec, type: :boolean, default: true, desc: "Include a helper spec file"
    desc "helper [NAME]", "Generates a helper"
    def helper(name)
      directory = File.expand_path ?.
      if File.exist? File.join(directory, '.eucalypt')
        helper = Eucalypt::Generators::Helper.new
        helper.destination_root = directory
        helper.generate(name: name, spec: options[:spec])
      else
        Eucalypt::Error.wrong_directory
      end
    end
  end
end