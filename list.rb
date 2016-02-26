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
puts ARGV[0]
puts ARGV[1]
listnamereq = ARGV[0].dup.prepend("list_")
listnameres = ARGV[0].dup.prepend("list_").concat("_response")
getname = ARGV[0].dup.prepend("get_")
getnameres = ARGV[0].dup.prepend("get_").concat("_response")

  params = { returnedTags: { 
        uuid: ''
        }, searchCriteria: {
          ARGV[1].to_sym => '%'
          }}

  begin
    response = client.call(listnamereq.to_sym) do 
      message params
    end
    puts response
    response.body[listnameres.to_sym][:return][ARGV[0].dup.to_sym].each do |r|
      uuid << r[:@uuid]
      puts uuid
    end
  end
  

uuid.each do |u|

  paramlist = { 
    uuid: u 
  }

  begin
  responselist = client.call(getname.to_sym) do
    message paramlist
    end
  end

puts responselist.body[getnameres.to_sym][:return].to_json
  
end

