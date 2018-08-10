require 'rails/generators/migration'

module Unitize
  module Generators
		class InstallGenerator < Rails::Generators::Base

      include Rails::Generators::Migration
  		source_root File.expand_path('../templates', __FILE__)

  		def self.next_migration_number(path)
        unless @prev_migration_nr
          @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        else
          @prev_migration_nr += 1
        end
        @prev_migration_nr.to_s
      end

      def create_tasks
        copy_file 'tasks/import_unitize.rake', 'lib/tasks/import_unitize.rake'
      end

      def create_initializers
        copy_file 'initializers/unitize.rb', 'config/initializers/unitize.rb'
      end

			def create_migrations
      	migration_template "migrations/create_measurement_types.rb.erb", "db/migrate/create_measurement_types.rb"
        migration_template "migrations/create_measurement_units.rb.erb", "db/migrate/create_measurement_units.rb"
      	migration_template "migrations/create_measurement_prefixes.rb.erb", "db/migrate/create_measurement_prefixes.rb"
    	end

		end
	end
end
