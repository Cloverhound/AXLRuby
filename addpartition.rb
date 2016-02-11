require 'savon'
require 'csv'

require_relative 'config'

path = 'partition.csv'

client = Savon.client(
      wsdl: "lib/axl/#{VERSION}/AXLAPI.wsdl",
      namespace: "http://www.cisco.com/AXL/API/#{VERSION}",
      endpoint: "https://#{IP}:8443/axl/",
      basic_auth: [USERNAME, PASSWORD],
      headers: {'Content-Type' => 'text/xml; charset=utf-8'},
      ssl_verify_mode: :none)


CSV.foreach(path, headers:true) do |row|

  params = { routePartition: { 
        name: row['NAME'],
        description: 'DESCRIPTION',
        routePartitionName: row['partition'],
        patternUrgency: row['urgent'],
        blockEnable: row['block_enable'],
        useCallingPartyPhoneMask: row['external_mask'],
        calledPartyTransformationMask: row['called_transform_mask'],
        callingPartyTransformationMask: row['calling_transform_mask'],
        digitDiscardInstructionName: row['discard'],
        dialPlanName: row['dialplan'],
        prefixDigitsOut: row['called_prefix_digits'],
        destination: { routeListName: row['routelist'] }}}

  begin
    response = client.call(:add_route_partition) do 
      message params
    end
  end

end