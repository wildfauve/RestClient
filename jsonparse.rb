require 'rest-client'
require 'json'

resource = RestClient::Resource.new 'http://localhost:3000/trees'
main = JSON.parse(resource.get(:accept => 'application/json'))
puts main.inspect