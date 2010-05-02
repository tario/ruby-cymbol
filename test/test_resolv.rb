require "test/unit"
require "ruby-cymbol"

class TestResolv < Test::Unit::TestCase
  def test_resolv
    # functions like rb_funcall, rb_ary_new, rb_define_module, rb_define_class must exists

    ["rb_funcall", "rb_ary_new", "rb_define_module", "rb_define_class"].each do |str|
      assert Cymbol.resolv(str).instance_of? Fixnum
    end
  end

  def test_not_found
    # functions like "01010101", "foo" ar NOT defined and must raise SymbolNotFound

    ["010101010","foo"].each do |str|
      assert_raise Cymbol::SymbolNotFound do
        Cymbol.resolv(str)
      end
    end

  end

end

