require 'savon'
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
    puts response
    response.body[:list_route_pattern_response][:return][:route_pattern].each do |r|
      uuid << r[:@uuid]
      puts uuid
    end
  end
  

uuid.each do |u|

  paramlist = { 
    uuid: u 
  }

  begin
  responselist = client.call(:get_route_pattern) do
    message paramlist
    end
  end

 # puts responselist.body[:get_route_pattern_response][:return].to_json
  
end

