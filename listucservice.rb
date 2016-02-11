require 'savon'
require 'csv'
require 'json'

require_relative 'config'

path = 'routepatterns.csv'
uuid = Array.new

client = Savon.client(
      wsdl: "lib/axl/#{VERSION}/AXLAPI.wsdl",
      namespace: "http://www.cisco.com/AXL/API/#{VERSION}",
      endpoint: "https://#{IP}:8443/axl/",
      basic_auth: [USERNAME, PASSWORD],
      headers: {'Content-Type' => 'text/xml; charset=utf-8'},
      ssl_verify_mode: :none)



  params = { returnedTags: { 
        name: ''
        }, searchCriteria: {
          name: '%'
          }}

  begin
    response = client.call(:list_uc_service) do 
      message params
    end
   # puts response.body
    response.body[:list_uc_service_response][:return][:uc_service].each do |r|
      uuid << r[:@uuid]
   #   puts uuid
    end
  end
  

# puts uuid
uuid.each do |u|

  paramlist = { 
    uuid: u 
  }

  begin
  responselist = client.call(:get_uc_service) do
    message paramlist
    end
  end

puts responselist.body[:get_uc_service_response][:return].to_json
  
end

