require 'minitest/unit'
require 'minitest/autorun'

class Minitest::Test

  def self.test desc = "anonymous", &block
    block ||= proc { skip "(no tests defined)" }

    @test_serial_number ||= 0
    @test_serial_number += 1

    name = "test_%04d_%s" % [ @test_serial_number, desc ]

    define_method name, &block

    name
  end

end