require 'savon'

require_relative 'config'

client = Savon.client(
wsdl: "lib/axl/#{VERSION}/AXLAPI.wsdl",
namespace: "http://www.cisco.com/AXL/API/#{VERSION}",
endpoint: "https://#{IP}:8443/axl/",
basic_auth: [USERNAME, PASSWORD],
headers: {'Content-Type' => 'text/xml; charset=utf-8'},
ssl_verify_mode: :none)


response = client.operations

puts response

