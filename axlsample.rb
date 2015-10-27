require 'sekken' 

version = "10.5"

client = Sekken.new("/Users/michaeltodd/axlruby/lib/axl/#{version}/AXLAPI.wsdl")


puts client.example_body(:list_h323_phone)
