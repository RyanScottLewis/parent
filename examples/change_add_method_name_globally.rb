require 'bundler/setup'
require_relative '../lib/parent'

class User < Struct.new(:name); end
class Element < Struct.new(:name); end

class Group < Parent
  def self.child_add_method_name(child_name)
    "create_#{child_name.singularize}"
  end
  
  def_child User
  def_child Element
end

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= #

group = Group.new
group.create_user 'John Doe'      # Notice how both the 'user' and 'element'
group.create_element 'My Element' # child collections now use the 'create_' helper

p group.users  # => [ #<struct User name="John Doe"> ]
p group.elements  # => [ #<struct Element name="My Element"> ]