# loading gems
require "unitize"
require "byebug"
require "factory_girl"

# loading factories for testing
require "factories/measurement_prefixes"
require "factories/measurement_types"
require "factories/measurement_units"

# used to add power function to dentaku
require "generators/unitize/templates/initializers/unitize"

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

require "support/schema"
require "support/preload_data"
