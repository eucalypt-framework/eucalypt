def find_migration(name)
  Dir[File.join('db', 'migrate', "*#{name}.rb")].first
end