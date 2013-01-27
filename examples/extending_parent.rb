require 'bundler/setup'
require_relative '../lib/parent'

class Node
  extend Parent::Base
  
  def_child :children, class: self
  
  attr_reader :text
  
  def initialize(text, &block)
    @text = text
    yield(self) if block_given?
  end
  
  def to_h
    result = { :text => @text }
    result[:children] = children.collect(&:to_h) unless children.empty?
    
    result
  end
end

require 'pp'

root_node = Node.new('Root Node')
root_node.add_child 'Child 1' do |child_node|
  child_node.add_child 'Grandchild 1'
  child_node.add_child 'Grandchild 2'
end

pp root_node.to_h
# => {
#      :text => "Root Node",
#      :children => [
#        {
#          :text => "Child 1",
#          :children => [
#            { :text => "Grandchild 1" },
#            { :text => "Grandchild 2" }
#          ]
#        }
#      ]
#    }