require 'nokogiri'
require 'rails'

require 'savon'
require 'json'

require_relative 'config'


client = Savon.client(
wsdl: "lib/axl/#{VERSION}/AXLAPI.wsdl",
namespace: "http://www.cisco.com/AXL/API/#{VERSION}",
endpoint: "https://#{IP}:8443/axl/",
basic_auth: [USERNAME, PASSWORD],
headers: {'Content-Type' => 'text/xml; charset=utf-8'},
ssl_verify_mode: :none)

doc = Nokogiri::XML(File.open("lib/axl/#{VERSION}/AXLSoap.xsd"))

doc.xpath("//xsd:complexType[starts-with(@name,'List')]//xsd:sequence//xsd:element[@name='searchCriteria']//xsd:complexType//xsd:sequence//xsd:element[@name]").each do |node|

	listname = node.parent.parent.parent.parent.parent['name']
	searchcriteria = node['name']
	puts listname.underscore + ' ' + searchcriteria



	params = { returnedTags: {
		uuid: ''
	}, searchCriteria: {
		searchcriteria.to_sym => '%'
	}}

	begin
		uuid = Array.new
		response = client.call(listname.underscore.gsub('_req', '').to_sym) do
			message params
		end
		puts response
		begin
			response.body[listname.underscore.gsub('_req', '').concat("_response").to_sym][:return][listname.underscore.gsub('list_', '').gsub('_req', '').to_sym].each do |r|
				uuid << r[:@uuid]
				puts uuid
			end
		#rescue
			puts "RESCUED"
		end
	#rescue
		puts "RESCUED AGAIN"
	end


	uuid.each do |u|

		paramlist = {
			uuid: u
		}

		begin
			responselist = client.call(listname.underscore.gsub('list_', 'get_').gsub('_req', '').to_sym) do
				message paramlist
			end
			puts responselist
		end

		puts responselist.body[listname.underscore.gsub('list_', 'get_').gsub('_req', '_response').to_sym][:return].to_json

	end

end