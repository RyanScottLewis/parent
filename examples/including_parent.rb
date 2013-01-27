require 'bundler/setup'
require_relative '../lib/parent'

# A very simple library with two classes
module SomeLibrary
  
  # A very simple object with a name attribute
  class Entity < Struct.new(:name); end
  
  # A very simple object with a uri attribute
  class Resource < Struct.new(:uri); end
  
end

class Container
  include Parent::Base
  
  def_child :entity, class: SomeLibrary::Entity
  def_child :resource, class: SomeLibrary::Resource
end

c1 = Container.new

p c1.entities  # => []
p c1.resources # => []

c1.add_entity 'my first entity'

p c1.entities  # => [ #<struct SomeLibrary::Entity name='my first entity'> ]
p c1.resources # => []

c1.add_resource 'http://my_first_entity.example.com'

p c1.entities  # => [ #<struct SomeLibrary::Resource uri='http://my_first_entity.example.com'> ]
p c1.resources # => []

c2 = Container.new

p c2.entities  # => []
p c2.resources # => []
