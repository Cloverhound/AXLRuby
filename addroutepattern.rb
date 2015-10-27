require 'savon'
require 'csv'

version = "10.5"
username = "admin"
password = "cciecollab"
ip = "172.16.54.12"
path = 'test.csv'

client = Savon.client(
      wsdl: "lib/axl/#{version}/AXLAPI.wsdl",
      namespace: "http://www.cisco.com/AXL/API/#{version}",
      endpoint: "https://#{ip}:8443/axl/",
      basic_auth: [username, password],
      headers: {'Content-Type' => 'text/xml; charset=utf-8'},
      ssl_verify_mode: :none)


CSV.foreach(path, headers:true) do |row|

  pattern = row['pattern']
  description = row['description']
  partition = row['partition']
  routelist = row['routelist']
  discard = row['discard']
  called_transform_mask = row['called_transform_mask']
  called_prefix_digits = row['called_prefix_digits']
  calling_transform_mask = row['calling_transform_mask']
  external_mask = row['external_mask']
  block_enable = row['block_enable']
  urgent = row['urgent']

  params = { routePattern: { 
        pattern: pattern,
        usage: 'Translation',
        description: description,
        routePartitionName: partition,
        patternUrgency: urgent,
        blockEnable: block_enable,
        useCallingPartyPhoneMask: external_mask,
        calledPartyTransformationMask: called_transform_mask,
        callingPartyTransformationMask: calling_transform_mask,
        digitDiscardInstructionName: discard,
        prefixDigitsOut: called_prefix_digits,
        destination: { routeListName: routelist }}}

  begin
    response = client.call(:add_route_pattern) do 
      message params
    end
  end

end