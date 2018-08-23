defmodule Etherscan.UtilTest do
  use ExUnit.Case, async: true

  alias Etherscan.Util

  describe "format_balance/1" do
    test "with valid balance converts to ether" do
      assert Util.format_balance("10000000000000000000000") == "10000.0"
    end
  end

  describe "convert/2" do
    test "converts wei to kwei" do
      assert Util.convert(1000, denomination: :kwei) == "1.0"
      assert Util.convert("1000", denomination: :kwei) == "1.0"
    end

    test "converts wei to mwei" do
      assert Util.convert(1_000_000, denomination: :mwei) == "1.0"
      assert Util.convert("1000000", denomination: :mwei) == "1.0"
    end

    test "converts wei to gwei/shannon/nano" do
      assert Util.convert(1_000_000_000, denomination: :gwei) == "1.0"
      assert Util.convert(1_000_000_000, denomination: :shannon) == "1.0"
      assert Util.convert(1_000_000_000, denomination: :nano) == "1.0"
      assert Util.convert("1000000000", denomination: :gwei) == "1.0"
      assert Util.convert("1000000000", denomination: :shannon) == "1.0"
      assert Util.convert("1000000000", denomination: :nano) == "1.0"
    end

    test "converts wei to szabo/micro" do
      assert Util.convert(1_000_000_000_000, denomination: :szabo) == "1.0"
      assert Util.convert(1_000_000_000_000, denomination: :micro) == "1.0"
      assert Util.convert("1000000000000", denomination: :szabo) == "1.0"
      assert Util.convert("1000000000000", denomination: :micro) == "1.0"
    end

    test "converts wei to finney/milli" do
      assert Util.convert(1_000_000_000_000_000, denomination: :finney) == "1.0"
      assert Util.convert(1_000_000_000_000_000, denomination: :milli) == "1.0"
      assert Util.convert("1000000000000000", denomination: :finney) == "1.0"
      assert Util.convert("1000000000000000", denomination: :milli) == "1.0"
    end

    test "converts wei to ether" do
      assert Util.convert(1_000_000_000_000_000_000, denomination: :ether) == "1.0"
      assert Util.convert("1000000000000000000", denomination: :ether) == "1.0"
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

  describe "wrap/2" do
    test "returns a tuple with the element and tag" do
      assert {:ok, "hello"} = Util.wrap("hello", :ok)
    end
  end

  describe "hex_to_number/1" do
    test "with valid hex converts to number" do
      assert {:ok, 0} = Util.hex_to_number("0x0")
      assert {:ok, 211} = Util.hex_to_number("0xd3")
      assert {:ok, 5_531_758} = Util.hex_to_number("0x54686e")
    end

    test "with invalid hex returns error" do
      assert {:error, "invalid hex - \"0x\""} = Util.hex_to_number("0x")
      assert {:error, "invalid hex - \"hello\""} = Util.hex_to_number("hello")
      assert {:error, "invalid hex - \"0xhello\""} = Util.hex_to_number("0xhello")
      assert {:error, "invalid hex - \"0d2d23d23\""} = Util.hex_to_number("0d2d23d23")
    end
  end

  describe "safe_hex_to_number/1" do
    test "with valid hex converts to number" do
      assert Util.safe_hex_to_number("0x0") == 0
      assert Util.safe_hex_to_number("0xd3") == 211
      assert Util.safe_hex_to_number("0x54686e") == 5_531_758
    end

    test "with invalid hex returns 0" do
      assert Util.safe_hex_to_number("0x") == 0
      assert Util.safe_hex_to_number("hello") == 0
      assert Util.safe_hex_to_number("0xhello") == 0
      assert Util.safe_hex_to_number("0d2d23d23") == 0
    end
  end

  describe "number_to_hex/1" do
    test "converts to hex" do
      assert Util.number_to_hex(4_735_742) == "0x4842FE"
    end

    test "with string number" do
      assert Util.number_to_hex("4735742") == "0x4842FE"
    end
  end
end
