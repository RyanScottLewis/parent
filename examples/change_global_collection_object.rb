require 'bundler/setup'
require_relative '../lib/parent'

# A very simple library with two classes
module SomeLibrary
  
  # A very simple object with a name attribute
  class Entity < Struct.new(:name); end
  
end

class Container
  include Parent::Base
  
  def self.child_create_collection_object
    Hash.new # This used to be `Array.new`
  end
  
  def_child :entity, class: SomeLibrary::Entity
  
  def add_entity(name)
    entities[name] = instantiate_entity(name) # instantiate_entity is a instance helper method that will return a new instance of Entity
  end
end

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= #

container = Container.new
container.add_entity 'my first entity'

p container.entities # => { "my first entity" => #<struct SomeLibrary::Entity name="my first entity"> }

container.add_entity 'another entity'

p container.entities['another entity'] # => #<struct SomeLibrary::Entity name="another entity">