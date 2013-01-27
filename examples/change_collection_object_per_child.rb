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
  
  def_child :entity, class: SomeLibrary::Entity, collection_object_proc: Proc.new { Hash.new }
  def_child :resources, class: SomeLibrary::Resource
  
  def add_entity(name)
    entities[name] = instantiate_entity(name) # instantiate_entity is a instance helper method that will return a new instance of Entity
  end
end

container = Container.new
container.add_entity 'my first entity'
container.add_resource 'http://www.example.com'

p container.entities # => { "my first entity" => #<struct SomeLibrary::Entity name="my first entity"> }
p container.resources # => [ #<struct SomeLibrary::Resource uri="http://www.example.com"> ]

container.add_entity 'another entity'

p container.entities['another entity'] # => #<struct SomeLibrary::Entity name="another entity">