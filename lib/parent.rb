require 'version'
require 'i18n'
require 'active_support/inflector'
require 'active_support/inflections'

# Parent allows an object to have a collection (or multiple collections) of children.
# 
# Objects can subclass Parent.
class Parent
  is_versioned
  
  # Base class for errors.
  class Error < StandardError; end
  
  # When a class is not given as an option to the {Parent::ClassMethods#def_child} method.
  class ClassNotGivenError < Error
    
    # The error message.
    def to_s
      <<-EOS
      The :class option must be given.
      If you know of an elegant way to infer the class to instantiate from the
      `child_name` argument, please fork, update the Parent::ClassMethods#def_child
      method, and submit a pull request at https://github.com/RyanScottLewis/parent
      EOS
    end
    
  end
  
  # When a collection object given does not respond to #call.
  class InvalidCollectionObject < Error
    
    def to_s
      'The :collection_object_proc option must respond to :call'
    end
    
  end
  
  # Class methods to be applied to "parent" classes.
  module ClassMethods
    
    # This method is called by {Parent::ClassMethods#def_child} to get the instance method name to define that will add a child to a set of children.
    # By default, this will singularize the `child_name` given and prepend "add_".
    # 
    # Override this class method to customize the method name.
    def child_add_method_name(child_name)
      "add_#{child_name.singularize}"
    end
    
    # This method is called by {Parent::ClassMethods#def_child} to get the instance method name to define that will contain a set of children.
    # By default, this will pluralize the `child_name` given.
    # 
    # Override this class method to customize the method name.
    def child_collection_method_name(child_name)
      child_name.pluralize
    end
    
    # This method is called by {Parent::ClassMethods#def_child} to get the instance variable name to define that will contain a set of children.
    # By default, this will call {#child_collection_method_name} with the `child_name` given and prepend "@".
    # 
    # Override this class method to customize the method name.
    def child_collection_instance_variable_name(child_name)
      "@#{ child_collection_method_name(child_name) }"
    end
    
    # This method is called by {Parent::ClassMethods#def_child} when instantiating the collection object which will contain a set of children.
    # By default, this will return a new Array instance.
    # 
    # Override this class method to customize the object which will contain the children.
    def child_create_collection_object
      Array.new
    end
    
    # This method is called by {Parent::ClassMethods#def_child} to get the instance method name to define that will instantiate a new child object of that type.
    # By default, this will singularize the `child_name` given and prepend "instantiate_".
    # 
    # Override this class method to customize the object which will contain the children.
    def child_instantiate_method_name(child_name)
      "instantiate_#{child_name.singularize}"
    end
    
    def def_child(child_name, options={})
      if child_name.is_a?(Class)
        options[:class] = child_name
        child_name = child_name.to_s.strip.downcase
      end
      
      raise TypeError unless options.respond_to?(:to_str) || options.respond_to?(:to_s)
      raise TypeError unless options.respond_to?(:to_hash) || options.respond_to?(:to_h)
      
      child_name = child_name.to_str rescue child_name.to_s
      child_name = child_name.strip.downcase
      options = options.to_hash rescue options.to_h
      
      raise InvalidCollectionObject if options.has_key?(:collection_object_proc) && !options[:collection_object_proc].respond_to?(:call)
      
      # TODO: add_method_name_proc, collection_method_name_proc, collection_instance_variable_name_proc, and instantiate_method_name_proc options
      options[:add_method_name] ||= method(:child_add_method_name)
      options[:collection_object_proc] ||= method(:child_create_collection_object)
      
      add_method_name = options[:add_method_name].call(child_name)
      instantiate_method_name = child_instantiate_method_name(child_name)
      collection_method_name = child_collection_method_name(child_name)
      collection_iv_name = child_collection_instance_variable_name(child_name)
      
      # meta-programmatically defining instance methods
      define_method(collection_method_name) do
        instance_variable_set(collection_iv_name, options[:collection_object_proc].call) unless instance_variable_defined?(collection_iv_name)
        instance_variable_get(collection_iv_name)
      end
      
      define_method(instantiate_method_name) do |*arguments, &block|
        options[:class].new(*arguments, &block)
      end
      
      define_method(add_method_name) do |*arguments, &block|
        send(collection_method_name) << send(instantiate_method_name, *arguments, &block)
      end
      
    end
    
  end
  
  # The Base module for Parent classes.
  # 
  # Objects can include or extend Parent::Base.
  module Base
    
    def self.included(receiver)
      receiver.extend(ClassMethods)
      # receiver.send(:include, MetaTools) # TODO: On the fence... lookin like I might want to, though.
    end
    
    def self.extended(receiver)
      receiver.extend(ClassMethods)
    end
    
  end
  
  include Base
  
end