require 'savon'
require 'csv'

require_relative 'config'

path = 'routepatterns.csv'

client = Savon.client(
      wsdl: "lib/axl/#{VERSION}/AXLAPI.wsdl",
      namespace: "http://www.cisco.com/AXL/API/#{VERSION}",
      endpoint: "https://#{IP}:8443/axl/",
      basic_auth: [USERNAME, PASSWORD],
      headers: {'Content-Type' => 'text/xml; charset=utf-8'},
      ssl_verify_mode: :none)



  params = { 
        uuid: '{AF9A715F-04B8-6B57-A251-6C8AEC737AC4}'
        }

  begin
    response = client.call(:get_route_pattern) do 
      message params
    end
  end
  
puts response.body

