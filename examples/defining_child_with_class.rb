require 'bundler/setup'
require_relative '../lib/parent'

class User
  def initialize(attributes={})
    @attributes = attributes
  end
end

class Group < Parent
  def_child User
end

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= #

group = Group.new
group.add_user name: 'John Doe', age: 30

p group.users  # => [ #<User:0x12eba98 @attributes={:name=>"John Doe", :age=>30}> ]
