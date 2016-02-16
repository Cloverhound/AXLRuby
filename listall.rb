require 'nokogiri'
require 'rails'
require 'savon'
require 'json'

require_relative 'config' # CUCM IP, username, password, version

client = Savon.client(
wsdl: "lib/axl/#{VERSION}/AXLAPI.wsdl",
namespace: "http://www.cisco.com/AXL/API/#{VERSION}",
endpoint: "https://#{IP}:8443/axl/",
basic_auth: [USERNAME, PASSWORD],
headers: {'Content-Type' => 'text/xml; charset=utf-8'},
ssl_verify_mode: :none)

responseoptions = client.operations # lists possible commands from namespace

doc = Nokogiri::XML(File.open("lib/axl/#{VERSION}/AXLSoap.xsd")) # opens XSD file to search namespace

doc.xpath("//xsd:complexType[starts-with(@name,'List')]//xsd:sequence//xsd:element[@name='searchCriteria']//xsd:complexType//xsd:sequence//xsd:element[@name][1]").each do |node| # find all searchCriteria elements

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

	unless "ldap_sync_custom_field" == itemnamesimple.to_s

		begin
			uuid = Array.new
			#name = Array.new
			response = client.call(listnamesimple.to_sym) do
				message params
			end
			begin
				response.body[listnameresponse.to_sym][:return][itemnamesimple.to_sym].each do |r| # puts each UUID into an array
					uuid << r[:@uuid]
					#	name << r[:@name]
				end
			rescue
				puts "NO " + listname + " FOUND"
				puts response.body
			end
		rescue # some list commands won't work with the returnedTags, this retries the command without them
			puts "RESCUED REQUEST CALL" + ' ' + itemnamesimple + ' ' + searchcriteria
			params = { searchCriteria: {
				searchcriteria.to_sym => '%'
			}}
			retry
		end

		unless "get_universal_device_template" == getnamesimple.to_s
			responseoptions.each do |existsget|
				if getnamesimple.to_s == existsget.to_s # checks to see if get command exists for related list command
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
							puts responselist.to_s
							puts paramlist
						end
						puts responselist.body[getnameresponse.to_sym][:return].to_json # converts get response to JSON
					end
				end
			end
		end
	end
end