require 'savon' 

version = "10.5"

client = Savon.client(
      wsdl: "lib/axl/#{version}/AXLAPI.wsdl",
      namespace: "http://www.cisco.com/AXL/API/#{version}",
      endpoint: "https://#{ip}:8443/axl/",
      basic_auth: [username, password],
      headers: {'Content-Type' => 'text/xml; charset=utf-8'},
      ssl_verify_mode: :none)

puts client.operations
