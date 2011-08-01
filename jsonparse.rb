require 'rest-client'

resource = RestClient::Resource.new 'http://localhost:3000/trees'
main = resource.get(:accept => 'application/json')
puts main.inspect