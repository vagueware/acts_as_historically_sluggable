class SlugMigrationGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.migration_template('add_slugs.rb', 'db/migrate')
    end
  end
  
  def file_name
    "create_slugs"
  end
end