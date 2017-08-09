module Unitize
  # Functional is an alterative function-based scale for atoms with a
  # non-linear (or non-zero y-intercept) scale. This is most commonly used for
  # temperatures. Known functions for converting to and from special atoms
  # are setup as class methods here.
  class Functional < Scale
    
    attr_reader :function_from, :function_to

    # Setup a new functional.
    # @param value [Numeric] The magnitude of the scale
    # @param unit [Unitize::Unit, String] The unit of the scale
    # @param function_name [String, Symbol] One of the class methods above to be
    # used for conversion
    def initialize(value, unit, function_from, function_to)
      @function_from = function_from
      @function_to = function_to
      super(value, unit)
    end

    # Get the equivalent scalar value of a magnitude on this scale
    # @param magnitude [Numeric] The magnitude to find the scalar value for
    # @return [Numeric] Equivalent linear scalar value
    # @api public
    def scalar(magnitude = value)
      Dentaku(function_from, x: magnitude)
    end

    # Get the equivalent magnitude on this scale for a scalar value
    # @param scalar [Numeric] A linear scalar value
    # @return [Numeric] The equivalent magnitude on this scale
    # @api public
    def magnitude(scalar = scalar())
      Dentaku(function_to, x: scalar)
    end
  end
end
