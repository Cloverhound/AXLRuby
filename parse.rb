require 'nokogiri'
require 'rails'

doc = Nokogiri::XML(File.open("lib/axl/9.1/AXLSoap.xsd"))

doc.xpath("//xsd:complexType[starts-with(@name,'List')]//xsd:sequence//xsd:element[@name='searchCriteria']//xsd:complexType//xsd:sequence//xsd:element[@name]").each do |node|
	listname = node.parent.parent.parent.parent.parent['name'] 
	searchcriteria = node['name']
	puts listname.underscore.gsub('_req', '') + ' ' + searchcriteria
end

