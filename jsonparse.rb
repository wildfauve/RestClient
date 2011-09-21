require 'rest-client'
require 'json'

class Transaction

  def initialize(desc, value, pts)
    @items = []
    @desc = desc
    @value = value
    @pts = pts
  end
  
  def add(item)
    @items << item
  end

  def to_hash
    thash = {:txn_description => @desc, :txn_value => @value, :calc_points => @pts }
    it = []
    @items.each do |item|
      it << {:code => item.code, :price => item.price}
    end
    thash["product"] = it
    puts thash
    return thash
  end

end

class Item
  attr_reader :code, :price
  def initialize(code, price)
    @code = code
    @price = price
  end
end


host = "http://localhost:3000"
resource = RestClient::Resource.new "#{host}/accounts"

resp = resource.get({:accept => 'application/vnd.loy+json', :params => {:card_id => 1234}})

#puts resp.code, resp

data = JSON::parse(resp)
#puts data

if data.has_key?('status')
  raise "Error"
end

t = Transaction.new("Test TXN", 100, 5)
t.add(Item.new("abc001", 99.09))
t.add(Item.new("abc002", 199.10))

puts t.inspect

data["accounts"].each do |links|
  lk = links["link"]
  puts lk["uri"]
  puts lk["rel"]
  if lk["desc"] == "flybuys"
    url = "#{host}#{lk["uri"]}"
    puts "found flybys"
    RestClient.post(url, t.to_hash)
  end
end