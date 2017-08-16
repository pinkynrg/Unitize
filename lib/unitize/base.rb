module Unitize
  # The base class that Atom and Prefix are extended from. This class provides
  # shared functionality for said classes.
  class Base
    liner :name, :code, :symbol, :scale
    include Memoizable

    # The list of tracked items.
    # @return [Array] An array of memoized instances.
    # @api public
    def self.all
      @all ||= data.map { |d| new d }
    end

    # Find a matching instance by a specified attribute.
    # @param string [String] The search term
    # @param method [Symbol] The attribute to search by
    # @return The first matching instance
    # @example
    #   Unitize::Atom.find('m')
    # @api public
    def self.find(string, method = :code)
      all.find do |i|
        key = i.send(method)
        if key.is_a? Array
          key.include?(string)
        else
          key == string
        end
      end
    end

    # Setter for the names attribute. Will always set as an array.
    # @api semipublic
    def names=(names)
      @names = Array(names)
    end

    # String representation for the instance.
    # @param mode [symbol] The attribute to for stringification
    # @return [String]
    # @api public
    def to_s(mode = :code)
      res = send(mode) || code
      res.respond_to?(:each) ? res.first.to_s : res.to_s
    end
  end
end
