module Temporary
  extend self

  DIRECTORY = File.join Dir.pwd, 'tmp'
  INIT_ARGS = %w[init tmp --no-git --no-bundle]

  def tmp(&block)
    Dir.chdir DIRECTORY, &block
  end

  def execute(command, silent: true)
    raise 'Must be in tmp directory' unless File.basename(Dir.pwd) == 'tmp'
    if silent
      silence { Eucalypt::CLI.start command.split }
    else
      Eucalypt::CLI.start command.split
    end
  end

  def delete(file)
    raise 'Must be in tmp directory' unless File.basename(Dir.pwd) == 'tmp'
    FileUtils.rm(file) if File.file? file
  end

  def execute_many(silent: true)
    raise 'Must be in tmp directory' unless File.basename(Dir.pwd) == 'tmp'
    yield builder = []
    command_call = Proc.new {|c| execute c, silent: silent }
    builder.send(silent ? :map : :each, &command_call)
  end

  class << self
    def clear
      FileUtils.rm_rf DIRECTORY if File.directory? DIRECTORY
    end

    def create
      FileUtils.mkdir DIRECTORY
    end

    def create_app(*additional)
      args = (INIT_ARGS.dup << additional).flatten
      silence { Eucalypt::CLI.start args }
    end
  end
end

=begin
output = tmp do
  execute_many do |t|
    t << 'blog setup'
    t << 'blog article list'
    t << 'blog article g test-article'
  end
end
=end