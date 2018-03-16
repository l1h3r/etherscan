defmodule Etherscan.Constants do
  @moduledoc """
  A module of compile-time constants that don't have to be repeatedly defined
  """

  defmacro __using__(_) do
    quote do
      # API
      @api_request_opts [
        timeout: 20_000,
        recv_timeout: 20_000,
      ]
      @api_network_urls [
        default: "https://api.etherscan.io/api",
        ropsten: "https://ropsten.etherscan.io/api",
        kovan:   "https://kovan.etherscan.io/api",
        rinkeby: "https://rinkeby.etherscan.io/api",
      ]
      @api_networks Keyword.keys(@api_network_urls)

      # Errors
      @error_invalid_address {:error, :invalid_address}
      @error_invalid_addresses {:error, :invalid_addresses}
      @error_invalid_transaction_hash {:error, :invalid_transaction_hash}
      @error_invalid_token_address {:error, :invalid_token_address}
      @error_invalid_index {:error, :invalid_index}
      @error_invalid_tag_and_index {:error, :invalid_tag_and_index}
      @error_invalid_tag {:error, :invalid_tag}
      @error_invalid_hex {:error, :invalid_hex}
      @error_invalid_to {:error, :invalid_to}
      @error_invalid_data {:error, :invalid_data}
      @error_invalid_to_and_data {:error, :invalid_to_and_data}
      @error_invalid_address_and_tag {:error, :invalid_address_and_tag}
      @error_invalid_position {:error, :invalid_position}
      @error_invalid_address_and_position {:error, :invalid_address_and_position}
      @error_invalid_params {:error, :invalid_params}
      @error_invalid_from_block {:error, :invalid_from_block}
      @error_invalid_to_block {:error, :invalid_to_block}
      @error_invalid_topic0_1_opr {:error, :invalid_topic0_1_opr}
      @error_invalid_topic1_2_opr {:error, :invalid_topic1_2_opr}
      @error_invalid_topic2_3_opr {:error, :invalid_topic2_3_opr}
      @error_invalid_block_number {:error, :invalid_block_number}
      @error_invalid_address_and_token_address {:error, :invalid_address_and_token_address}

      # Tests
      @test_address1 "0xddbd2b932c763ba5b1b7ae3b362eac3e8d40121a"
      @test_address2 "0x63a9975ba31b0b9626b34300f7f627147df1f526"
      @test_address3 "0x198ef1ec325a96cc354c7266a038be8b5c558f67"
      @test_miner_address "0x9dd134d14d1e65f84b706d6f205cd5b1cd03a46b"
      @test_token_address "0x57d90b64a1a57749b0f932f1a3395792e12e7055"
      @test_contract_address "0xBB9bc244D798123fDe783fCc1C72d3Bb8C189413"
      @test_token_owner_address "0xe04f27eb70e025b78871a2ad7eabe85e61212761"
      @test_transaction_hash "0x40eb908387324f2b575b4879cd9d7188f69c8fc9d87c901b9e2daaea4b442170"
      @test_transaction_hash_2 "0x513c1ba0bebf66436b5fed86ab668452b7805593c05073eb2d51d3a52f480a76"
      @test_invalid_transaction_hash "0x15f8e5ea1079d9a0bb04a4c58ae5fe7654b5b2b4463375ff7ffb490aa0032f3a"

      @test_topic_address "0x33990122638b9132ca29c723bdf037f1a891a70c"
      @test_topic_0 "0xf63780e752c6a54a94fc52715dbc5518a3b4c3c2833d301a204226548a2a8545"
      @test_topic_1 "0x72657075746174696f6e00000000000000000000000000000000000000000000"

      @test_address1_balance "40807.16856407000159379095"
      @test_address2_balance "332.56713622282705955513"
      @test_address3_balance "3213.39747044394698605174"
      @test_token_address_balance 135499

      @test_token_supply 21265524714464
      @test_block_number 2165403
      @test_eth_supply "96392916.78030000627040863037"
      @test_eth_btc_price "0.03656"
      @test_eth_usd_price "715.8"

      @test_proxy_block_number 4747852
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
      @test_proxy_current_gas 21000000000
      @test_proxy_block_transaction_count 3
      @test_proxy_transaction_count 44893
      @test_proxy_eth_call_result "0x00000000000000000000000000000000000000000000000000601d8888141c00"
      @test_proxy_storage_result "0x0000000000000000000000003d0768da09ce77d25e2d998e6a7b6ed4b9116c2d"
      @test_proxy_code_result "0x3660008037602060003660003473273930d21e01ee25e4c219b63259d214872220a261235a5a03f21560015760206000f3"
    end
  end
end
