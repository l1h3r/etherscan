defmodule Etherscan.Factory do
  @moduledoc """
  Etherscan factory module.
  """

  @address1 "0xddbd2b932c763ba5b1b7ae3b362eac3e8d40121a"
  @address2 "0x63a9975ba31b0b9626b34300f7f627147df1f526"
  @address3 "0x198ef1ec325a96cc354c7266a038be8b5c558f67"
  @miner_address "0x9dd134d14d1e65f84b706d6f205cd5b1cd03a46b"
  @token_address "0x57d90b64a1a57749b0f932f1a3395792e12e7055"
  @contract_address "0xBB9bc244D798123fDe783fCc1C72d3Bb8C189413"
  @token_owner_address "0xe04f27eb70e025b78871a2ad7eabe85e61212761"
  @transaction_hash "0x40eb908387324f2b575b4879cd9d7188f69c8fc9d87c901b9e2daaea4b442170"
  @invalid_transaction_hash "0x15f8e5ea1079d9a0bb04a4c58ae5fe7654b5b2b4463375ff7ffb490aa0032f3a"

  @topic_address "0x33990122638b9132ca29c723bdf037f1a891a70c"
  @topic_0 "0xf63780e752c6a54a94fc52715dbc5518a3b4c3c2833d301a204226548a2a8545"
  @topic_1 "0x72657075746174696f6e00000000000000000000000000000000000000000000"

  @address1_balance 40807168564070000000000
  @address2_balance 332567136222827062478
  @address3_balance 145328094095564037222
  @token_address_balance 135499

  @token_supply 21265524714464
  @block_number 2165403
  @eth_supply 96244925280300000000000000
  @eth_btc_price "0.0322"
  @eth_usd_price "439.72"

  @proxy_block_number "0x47d0e0"
  @proxy_block_tag "0x10d4f"
  @proxy_uncle_tag "0x210A9B"
  @proxy_uncle_block_tag "0x210a99"
  @proxy_transaction_tag "0x10FB78"
  @proxy_index "0x0"
  @proxy_transaction_hash "0x1e2910a262b1008d0616a0beb24c1a491d78771baa54a33e66065e03b1f46bc1"
  @proxy_address "0x2910543af39aba0cd09dbb2d50200b3e800a63d2"
  @proxy_hex "0xf904808000831cfde080"
  @proxy_to "0xAEEF46DB4855E25702F8237E8f403FddcaF931C0"
  @proxy_data "0x70a08231000000000000000000000000e16359506c028e51f16be38986ec5746251e9724"
  @proxy_code_address "0xf75e354c5edc8efed9b59ee9f67a80845ade7d0c"
  @proxy_storage_address "0x6e03d9cce9d60f3e9f2597e13cd4c54c55330cfd"
  @proxy_storage_position "0x0"
  @proxy_estimate_to "0xf0160428a8552ac9bb7e050d90eeade4ddd52843"
  @proxy_value "0xff22"
  @proxy_gas_price "0x051da038cc"
  @proxy_gas "0xffffff"
  @proxy_current_gas "0x98bca5a00"
  @proxy_block_transaction_count "0x3"
  @proxy_transaction_count "0xaf5d"
  @proxy_eth_call_result "0x00000000000000000000000000000000000000000000000000601d8888141c00"
  @proxy_storage_result "0x0000000000000000000000003d0768da09ce77d25e2d998e6a7b6ed4b9116c2d"
  @proxy_code_result "0x3660008037602060003660003473273930d21e01ee25e4c219b63259d214872220a261235a5a03f21560015760206000f3"

  def address1, do: @address1
  def address2, do: @address2
  def address3, do: @address3
  def miner_address, do: @miner_address
  def token_address, do: @token_address
  def contract_address, do: @contract_address
  def token_owner_address, do: @token_owner_address
  def transaction_hash, do: @transaction_hash
  def invalid_transaction_hash, do: @invalid_transaction_hash

  def topic_address, do: @topic_address
  def topic_0, do: @topic_0
  def topic_1, do: @topic_1

  def address1_balance, do: @address1_balance
  def address2_balance, do: @address2_balance
  def address3_balance, do: @address3_balance
  def token_address_balance, do: @token_address_balance

  def token_supply, do: @token_supply
  def block_number, do: @block_number
  def eth_supply, do: @eth_supply
  def eth_btc_price, do: @eth_btc_price
  def eth_usd_price, do: @eth_usd_price

  def proxy_block_number, do: @proxy_block_number
  def proxy_block_tag, do: @proxy_block_tag
  def proxy_uncle_tag, do: @proxy_uncle_tag
  def proxy_uncle_block_tag, do: @proxy_uncle_block_tag
  def proxy_transaction_tag, do: @proxy_transaction_tag
  def proxy_index, do: @proxy_index
  def proxy_transaction_hash, do: @proxy_transaction_hash
  def proxy_address, do: @proxy_address
  def proxy_hex, do: @proxy_hex
  def proxy_to, do: @proxy_to
  def proxy_data, do: @proxy_data
  def proxy_code_address, do: @proxy_code_address
  def proxy_storage_address, do: @proxy_storage_address
  def proxy_storage_position, do: @proxy_storage_position
  def proxy_estimate_to, do: @proxy_estimate_to
  def proxy_value, do: @proxy_value
  def proxy_gas_price, do: @proxy_gas_price
  def proxy_gas, do: @proxy_gas
  def proxy_current_gas, do: @proxy_current_gas
  def proxy_block_transaction_count, do: @proxy_block_transaction_count
  def proxy_transaction_count, do: @proxy_transaction_count
  def proxy_eth_call_result, do: @proxy_eth_call_result
  def proxy_storage_result, do: @proxy_storage_result
  def proxy_code_result, do: @proxy_code_result
end
