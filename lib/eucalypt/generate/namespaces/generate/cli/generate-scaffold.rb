require 'thor'
require 'eucalypt/helpers'
require 'eucalypt/app'
module Eucalypt
  class Generate < Thor
    include Eucalypt::Helpers
    include Eucalypt::Helpers::Messages
    using Colorize

    option :no, aliases: '-n', type: :array, default: [], enum: %w[m ms c cs h hs], desc: "Omit specified scaffold files"
    option :rest, aliases: '-r', type: :boolean, default: false,  desc: "Generate REST routes for the controller"
    option :policy, aliases: '-p', type: :boolean, default: false, desc: "Generate a policy with the scaffold"
    option :headless, type: :boolean, aliases: '-H', default: false, desc: "Policy with no associated model"
    option :table, type: :boolean, default: true, desc: "Generate a table migration"
    desc "scaffold [NAME] *[COLUMN∶TYPE]", "Generates a scaffold".colorize(:grey)
    def scaffold(name, *columns)
      directory = File.expand_path('.')
      if Eucalypt.app? directory
        model = !options[:no].include?('m')
        helper = !options[:no].include?('h')
        controller = !options[:no].include?('c')
        model_spec = !options[:no].include?('ms')
        helper_spec = !options[:no].include?('hs')
        controller_spec = !options[:no].include?('cs')

        if model
          validation = Eucalypt::Helpers::Migration::Validation.new columns
          return if validation.any_invalid?
          model = Eucalypt::Generators::Model.new
          model.destination_root = directory
          model.generate(name: name, spec: model_spec, table: options[:table], columns: columns)
        end

        if helper
          helper = Eucalypt::Generators::Helper.new
          helper.destination_root = directory
          helper.generate(name: name, spec: helper_spec)
        end

        if controller
          controller = Eucalypt::Generators::Controller.new
          controller.destination_root = directory
          policy = options[:rest] && options[:policy]
          headless = options[:policy] && options[:headless]
          controller.generate(
            name: name,
            spec: controller_spec,
            rest: options[:rest],
            policy: policy,
            headless: headless
          )
        end

        if options[:policy]
          args = ['security', 'policy', 'generate', name]
          args << '--headless' if options[:headless]
          args << %w[-p read add edit delete] if options[:rest]
          args.flatten!
          Eucalypt::CLI.start(args)
        end
      else
        Eucalypt::Error.wrong_directory
      end
    end
  end
end