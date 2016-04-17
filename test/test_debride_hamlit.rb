require "minitest/autorun"
require "debride_hamlit"
require "tempfile"

module TestDebride; end

class TestDebride::TestHamlit < Minitest::Test
  def test_process_haml
    file = Tempfile.new ['debride-hamlit-test', '.haml']

    file.write(<<-HAML.strip)
%p
= 1/0
- "foo"
    HAML

    file.flush

    sexp = Debride.new.process_haml file.path

    # Output from Hamlit 2.2.3
    expected = s(:block, s(:lasgn, :_buf, s(:array)), s(:call, s(:lvar, :_buf), :<<, s(:call, s(:str, "<p></p>\n"), :freeze)), s(:lasgn, :_hamlit_compiler1, s(:call, s(:lit, 1), :/, s(:lit, 0))), s(:call, s(:lvar, :_buf), :<<, s(:call, s(:colon2, s(:colon3, :Hamlit), :Utils), :escape_html, s(:call, s(:lvar, :_hamlit_compiler1), :to_s))), s(:call, s(:lvar, :_buf), :<<, s(:call, s(:str, "\n"), :freeze)), s(:str, "foo"), s(:lasgn, :_buf, s(:call, s(:lvar, :_buf), :join)))

    assert_equal expected, sexp
  end
end
