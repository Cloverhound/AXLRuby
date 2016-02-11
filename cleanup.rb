require 'savon'
require 'csv'
require 'json'

require_relative 'config'

uuid = Array.new

client = Savon.client(
      wsdl: "lib/axl/#{VERSION}/AXLAPI.wsdl",
      namespace: "http://www.cisco.com/AXL/API/#{VERSION}",
      endpoint: "https://#{IP}:8443/axl/",
      basic_auth: [USERNAME, PASSWORD],
      headers: {'Content-Type' => 'text/xml; charset=utf-8'},
      ssl_verify_mode: :none)



  params = { returnedTags: { 
        uuid: ''
        }, searchCriteria: {
          pattern: '%'
          }}

  begin
    response = client.call(:list_route_pattern) do 
      message params
    end
    puts response.body
  end
 