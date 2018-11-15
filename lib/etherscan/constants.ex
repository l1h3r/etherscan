defmodule Etherscan.Constants do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      @test_block 2_165_403
      @test_wallet_1 "0xddbd2b932c763ba5b1b7ae3b362eac3e8d40121a"
      @test_wallet_2 "0x63a9975ba31b0b9626b34300f7f627147df1f526"
      @test_wallet_3 "0x198ef1ec325a96cc354c7266a038be8b5c558f67"
      @test_miner "0x9dd134d14d1e65f84b706d6f205cd5b1cd03a46b"
      @test_token "0x57d90b64a1a57749b0f932f1a3395792e12e7055"
      @test_token_owner "0xe04f27eb70e025b78871a2ad7eabe85e61212761"
      @test_contract "0xBB9bc244D798123fDe783fCc1C72d3Bb8C189413"
      @test_transaction_success "0x40eb908387324f2b575b4879cd9d7188f69c8fc9d87c901b9e2daaea4b442170"
      @test_transaction_error "0x15f8e5ea1079d9a0bb04a4c58ae5fe7654b5b2b4463375ff7ffb490aa0032f3a"
      @test_transaction_receipt "0x513c1ba0bebf66436b5fed86ab668452b7805593c05073eb2d51d3a52f480a76"
      @test_topic_address "0x33990122638b9132ca29c723bdf037f1a891a70c"
      @test_topic_1 "0xf63780e752c6a54a94fc52715dbc5518a3b4c3c2833d301a204226548a2a8545"
      @test_topic_2 "0x72657075746174696f6e00000000000000000000000000000000000000000000"

      @test_proxy_block_number 6_196_278
      @test_proxy_block_tag "0x10d4f"
      @test_proxy_uncle_tag "0x210A9B"
      @test_proxy_uncle_block_tag "0x210a99"
      @test_proxy_transaction_tag "0x10FB78"
      @test_proxy_index "0x0"
      @test_proxy_transaction_hash "0x1e2910a262b1008d0616a0beb24c1a491d78771baa54a33e66065e03b1f46bc1"
      @test_proxy_address "0x2910543af39aba0cd09dbb2d50200b3e800a63d2"
      @test_proxy_hex "0xf904808000831cfde080"
      @test_proxy_to "0xAEEF46DB4855E25702F8237E8f403FddcaF931C0"
      @test_proxy_data "0x70a08231000000000000000000000000e16359506c028e51f16be38986ec5746251e9724"
      @test_proxy_code_address "0xf75e354c5edc8efed9b59ee9f67a80845ade7d0c"
      @test_proxy_storage_address "0x6e03d9cce9d60f3e9f2597e13cd4c54c55330cfd"
      @test_proxy_storage_position "0x0"
      @test_proxy_estimate_to "0xf0160428a8552ac9bb7e050d90eeade4ddd52843"
      @test_proxy_value "0xff22"
      @test_proxy_gas_price "0x051da038cc"
      @test_proxy_gas "0xffffff"
      @test_proxy_current_gas 2_100_000_000
      @test_proxy_block_transaction_count 3
      @test_proxy_transaction_count 44_893
      @test_proxy_eth_call_result "0x00000000000000000000000000000000000000000000000000601d8888141c00"
      @test_proxy_storage_result "0x0000000000000000000000003d0768da09ce77d25e2d998e6a7b6ed4b9116c2d"
      @test_proxy_code_result "0x3660008037602060003660003473273930d21e01ee25e4c219b63259d214872220a261235a5a03f21560015760206000f3"
    end
  end
end
