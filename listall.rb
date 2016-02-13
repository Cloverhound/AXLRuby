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

	listname = node.parent.parent.parent.parent.parent['name'] # List name from XSD (e.g. "ListSipProfileReq")
	searchcriteria = node['name'] # Used for searchCriteria in listname request (e.g. "name")
	listnamesimple = listname.underscore.gsub('_req', '') # List name in underscore format without _req (e.g. "list_sip_profile")
	listnameresponse = listname.underscore.gsub('_req', '').concat("_response") # Match list response header (e.g. list_sip_profile_response)
	itemnamesimple = listname.underscore.gsub('list_', '').gsub('_req', '') # Just the item name (e.g. "sip_profile")
	getnamesimple = listname.underscore.gsub('list_', 'get_').gsub('_req', '') # Get item name (e.g. get_sip_profile")
	getnameresponse = listname.underscore.gsub('list_', 'get_').gsub('_req', '_response') # Get item with response (e.g. "get_sip_profile_response")

	params = { returnedTags: {
		uuid: ''
	},searchCriteria: {
		searchcriteria.to_sym => '%'
	}}


=begin Without returnedTags

params = { searchCriteria: {
		searchcriteria.to_sym => '%'
	}}
=end

	begin
		uuid = Array.new
		response = client.call(listnamesimple.to_sym) do
			message params
		end
		begin
			response.body[listnameresponse.to_sym][:return][itemnamesimple.to_sym].each do |r|
				uuid << r[:@uuid]
				#	puts uuid
			end
		rescue
			puts "RESCUED RESPONSE BODY" + ' ' + listname
			puts response.body
		end
	rescue
		puts "RESCUED REQUEST CALL" + ' ' + listname + ' ' + searchcriteria
	end


	uuid.each do |u|

		paramlist = {
			uuid: u
		}

		begin
			responselist = client.call(getnamesimple.to_sym) do
				message paramlist
			end
		rescue
			puts "RESCUED GET CALL" + ' ' + getnamesimple + ' ' + u
			puts paramlist
		end

		#puts responselist.body[getnameresponse.to_sym][:return].to_json

	end

end