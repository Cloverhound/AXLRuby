require 'nokogiri'

doc = Nokogiri::XML(File.open("lib/axl/10.5/AXLSoap.xsd"))

doc.xpath("//xsd:complexType[starts-with(@name,'List')]//xsd:sequence//xsd:element[@name='searchCriteria']//xsd:complexType//xsd:sequence//xsd:element[@name]").each do |node|
	listname = node.parent.parent.parent.parent.parent['name'] 
	searchcriteria = node['name']
	puts listname + ' ' + searchcriteria
end

