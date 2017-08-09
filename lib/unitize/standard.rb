require 'net/http'
require 'nori'
require 'unitize/standard/base'
require 'unitize/standard/prefix'
require 'unitize/standard/base_unit'
require 'unitize/standard/derived_unit'
require 'unitize/standard/scale'
require 'unitize/standard/function'

module Unitize
  # The Standard module is responsible for fetching the UCUM specification unit
  # standards and translating them into yaml files. This code is only used for
  # by the rake task `rake unitize:update_standard` and as such is not
  # normally loaded.
  module Standard
    HOST = "unitsofmeasure.org"
    PATH = "/ucum-essence.xml"

    class << self
      def body
        @body ||= Net::HTTP.get HOST, PATH
      end

      def hash
        Nori.new.parse(body)["root"]
      end
    end
  end
end
