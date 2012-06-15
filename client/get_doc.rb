require 'json'
require 'openssl'
require 'base64'
require 'encryptor'

#retrieve all documents for a person in a context using a token
token='9422250d510137e15b6fdd'
#echo 'token: '$token

documents = `curl http://localhost:3000/api/all \
-H "Accept: application/json" \
-H "Authorization: OAuth2 #{token}"`

private_key = OpenSSL::PKey::RSA.new(File.read("./private.pem"))

puts private_key.private?
puts private_key.public_key

documents.each_line do |document|
	json = JSON.parse document
	cipher = json["key"]["cipher"]
	if(cipher == nil)
		next
	end
	decoded = Base64.decode64(cipher)
	sym_key = private_key.private_decrypt(decoded)
	puts "sym key: #{sym_key}"
	json["key"].each do |key,value|
		if(key == "cipher" || key == "_id" || key == "_rev" || key =="type" || key == "date")
			puts "#{key}:#{value}"
		else
 			dv = Encryptor.decrypt(Base64.decode64(value), :key => sym_key)
			puts "#{key}:#{dv}"
		end
	end
end
