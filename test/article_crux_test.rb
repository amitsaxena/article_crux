require 'test_helper'

class ArticleCruxTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::ArticleCrux::VERSION
  end

  def test_fetch_for_example_dot_com
    res = ArticleCrux.fetch("http://example.com/")
    assert_equal("Example Domain", res[:title])
  end
end
