defmodule CryptoBunny.CoinGeckoTest do
  use ExUnit.Case

  alias CryptoBunny.CoinGecko

  @coins_ids ["bit-cash", "bitcoin", "dogecoin"]
  @invalid_input [nil, 7, [], 'a']

  describe "External Coin Gecko API" do
    @tag :external
    test "search/1 returns an object containing coins, categories, markets data on valid search text" do
      assert {:ok, _data} = CoinGecko.search("bit")
    end

    @tag :external
    test "get_by_id/1 returns coins details on valid id" do
      valid_id = Enum.random(@coins_ids)
      assert {:ok, _data} = CoinGecko.get_by_id(valid_id)
    end

    @tag :external
    test "get_market_data/4 returns historical market chart data on valid id" do
      valid_id = Enum.random(@coins_ids)
      assert {:ok, _data} = CoinGecko.get_market_chart(valid_id)
    end

    @tag :external
    test "search/1 returns error tuple on invalid search text" do
      invalid_search_text = Enum.random(@invalid_input)
      assert {:error, _data} = CoinGecko.search(invalid_search_text)
    end

    @tag :external
    test "get_market_data/4 returns error tuple on invalid coin id" do
      invalid_id = Enum.random(@invalid_input)
      assert {:error, _data} = CoinGecko.get_market_chart(invalid_id)
    end
  end
end
