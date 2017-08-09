require 'test_helper'

class Unitize::Test < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, Unitize
  end
end
