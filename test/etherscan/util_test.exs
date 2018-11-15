defmodule Etherscan.UtilTest do
  use ExUnit.Case, async: true
  alias Etherscan.Util

  describe "convert/2" do
    test "converts wei to kwei" do
      assert Util.convert(1000, as: :kwei) == "1.0"
      assert Util.convert("1000", as: :kwei) == "1.0"
    end

    test "converts wei to mwei" do
      assert Util.convert(1_000_000, as: :mwei) == "1.0"
      assert Util.convert("1000000", as: :mwei) == "1.0"
    end

    test "converts wei to gwei/shannon/nano" do
      assert Util.convert(1_000_000_000, as: :gwei) == "1.0"
      assert Util.convert(1_000_000_000, as: :shannon) == "1.0"
      assert Util.convert(1_000_000_000, as: :nano) == "1.0"
      assert Util.convert("1000000000", as: :gwei) == "1.0"
      assert Util.convert("1000000000", as: :shannon) == "1.0"
      assert Util.convert("1000000000", as: :nano) == "1.0"
    end

    test "converts wei to szabo/micro" do
      assert Util.convert(1_000_000_000_000, as: :szabo) == "1.0"
      assert Util.convert(1_000_000_000_000, as: :micro) == "1.0"
      assert Util.convert("1000000000000", as: :szabo) == "1.0"
      assert Util.convert("1000000000000", as: :micro) == "1.0"
    end

    test "converts wei to finney/milli" do
      assert Util.convert(1_000_000_000_000_000, as: :finney) == "1.0"
      assert Util.convert(1_000_000_000_000_000, as: :milli) == "1.0"
      assert Util.convert("1000000000000000", as: :finney) == "1.0"
      assert Util.convert("1000000000000000", as: :milli) == "1.0"
    end

    test "converts wei to ether" do
      assert Util.convert(1_000_000_000_000_000_000, as: :ether) == "1.0"
      assert Util.convert("1000000000000000000", as: :ether) == "1.0"
    end
  end

  describe "pretty_float/1" do
    test "returns float as a string" do
      assert Util.pretty_float(0.000034140807) == "0.000034140807"
    end
  end

  describe "pretty_float/2" do
    test "returns float as a string" do
      assert Util.pretty_float(0.000034140807, 8) == "0.00003414"
    end

    test "with string float" do
      assert Util.pretty_float("0.000034140807", 8) == "0.00003414"
    end
  end
end
