module Eucalypt
  def self.set_root(root)
    const_set :ROOT, root.freeze

    define_singleton_method :root do
      const_get :ROOT
    end

    define_singleton_method :path do |*args|
      File.join self.root, *args
    end

    define_singleton_method :glob do |*args, &block|
      Dir.glob self.path(*args), &block
    end

    define_singleton_method :require do |*args|
      self.glob *args, &Kernel.method(:require)
    end
  end
end