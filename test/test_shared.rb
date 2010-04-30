require "test/unit"
require "ruby-cymbol/shared"

class TestSharedRead < Test::Unit::TestCase
	def test_shared
		assert_not_nil Cymbol.ruby_shared_name

    unless Cymbol.ruby_shared_name =~ /libruby/
      flunk "The library returned by ruby_shared_name isnt libruby"
    end

    unless File.exist?(Cymbol.ruby_shared_name)
      flunk "The library returned by ruby_shared_name doesn't exists in the system"
    end

	end
end
