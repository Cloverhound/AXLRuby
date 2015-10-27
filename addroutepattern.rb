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

  params = { routePattern: { 
        pattern: row['pattern'],
        usage: 'Translation',
        description: row['description'],
        routePartitionName: row['partition'],
        patternUrgency: row['urgent'],
        blockEnable: row['block_enable'],
        useCallingPartyPhoneMask: row['external_mask'],
        calledPartyTransformationMask: row['called_transform_mask'],
        callingPartyTransformationMask: row['calling_transform_mask'],
        digitDiscardInstructionName: row['discard'],
        prefixDigitsOut: row['called_prefix_digits'],
        destination: { routeListName: row['routelist'] }}}

  begin
    response = client.call(:add_route_pattern) do 
      message params
    end
  end

end