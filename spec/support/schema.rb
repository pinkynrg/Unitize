ActiveRecord::Schema.define do
  self.verbose = false

  create_table :measurement_prefixes do |t|
    t.string :name
    t.string :symbol
    t.string :code
    t.string :scalar
	  t.timestamps
  end

  create_table :measurement_types do |t|
    t.string :name
    t.timestamps
  end

  create_table :measurement_units do |t|
    t.string :name
    t.references :measurement_type, foreign_key: true
    t.string :code
    t.float :scale_value
    t.string :scale_unit_code
    t.string :classification
    t.boolean :metric, default: false
    t.boolean :base, default: false
    t.string :symbol
    t.string :scale_function_from
    t.string :scale_function_to
    t.timestamps
  end

end