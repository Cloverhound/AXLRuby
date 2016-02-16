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
        name: 'Auto-registration Template'
        }

  begin
    response = client.call(:get_universal_device_template) do 
      message params
    end
  end
  
puts response.body

