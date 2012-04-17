require 'teststrap.rb'

context "A simple array" do

  setup { Array.new }

  asserts("is empty") { topic.empty? }

  context "with one element" do
    setup { topic << "foo" }
    asserts("array is not empty") { !topic.empty? }
    asserts("returns the element on #first") { topic.first == "foo" }  
	end

end 

context "Another simple array" do

  setup { Array.new }

  asserts("is empty") { topic.empty? }
end

#unit tests to implement:

#application is denied access to documents specific datacontext
#application is denied access to documents specific personal context
#applcation is denied access to documents in specific personal context for a named scope
#application is granted access to documents in a specific datacontext
#application is granted access to documents specific personal context
#application is granted access to documents in a specific personal context for a named scope

