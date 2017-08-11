Dentaku::AST::Function.register(:pow, :numeric, ->(mantissa, exponent) { mantissa ** exponent })
Unitize.preload