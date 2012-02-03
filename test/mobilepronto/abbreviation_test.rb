# encoding: UTF-8

require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

describe MobilePronto::Abbreviation do
  before do
    @klass = MobilePronto::Abbreviation
  end

  describe "" do
    it "should be abbreviation to limit" do
      name = "Daniel Boo Sulivan"
      assert_equal name, @klass.abbr(name)
      assert_equal "Daniel Boo Sulivan", @klass.abbr(name)
      assert_equal "Daniel Boo Sulivan", @klass.abbr(name, name.size + 4)
      assert_equal "Daniel B. Sulivan" , @klass.abbr(name, name.size - 1)
      assert_equal "Daniel B. S."      , @klass.abbr(name, name.size - 5)
      assert_equal "Daniel", @klass.abbr("Daniel", 3)
    end
  end
end

