require 'unitize/expression/matcher'
require 'unitize/expression/parser'
require 'unitize/expression/transformer'
require 'unitize/expression/composer'
require 'unitize/expression/decomposer'

module Unitize
  # The Expression module encompases all functions around encoding and decoding
  # strings into Measurement::Units and vice-versa.
  module Expression
    class << self
      # Build a string representation of a collection of terms
      # @param terms [Array]
      # @return [String]
      # @example
      #   Unitize::Expression.compose(terms) # => "m2/s2"
      # @api public
      def compose(terms, method = :code)
        Composer.new(terms, method).expression
      end

      # Convert a string representation of a unit into an array of terms
      # @param expression [String] The string you wish to convert
      # @return [Array]
      # @example
      #   Unitize::Expression.decompose("m2/s2")
      #   # => [<Unitize::Term m2>, <Unitize::Term s-2>]
      # @api public
      def decompose(expression)
        Decomposer.parse(expression)
      end

    end
  end
end
