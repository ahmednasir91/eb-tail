require 'minitest/autorun'
require 'eb-tail'

class EbTailTest < Minitest::Test
	def test_configure_flags_set_options_configure_to_true
		@ebtail = EBTail::Main.new
		@ebtail.instance_variable_set("@environments", {})

		opts = @ebtail.apply_args!(["-c"])
		assert_equal true, opts.do_configure
	end
end
