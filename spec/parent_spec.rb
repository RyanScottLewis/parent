require 'spec_helper'

class ParentSubclassed < Parent; end
class ParentIncluded < Parent; include Parent::Base; end
class ParentExtended < Parent; extend Parent::Base; end

shared_examples 'a parent class' do
  
  it 'acts like a parent' do
    subject.should respond_to(:child_add_method_name)
    subject.should respond_to(:child_collection_method_name)
    subject.should respond_to(:child_collection_instance_variable_name)
    subject.should respond_to(:child_create_collection_object)
    subject.should respond_to(:child_instantiate_method_name)
    subject.should respond_to(:def_child)
  end
  
  describe '#child_add_method_name' do
    it 'should singularize the `child_name` given and prepend "add_"' do
      subject.child_add_method_name('entities').should == 'add_entity'
      subject.child_add_method_name('entity').should == 'add_entity'
      subject.child_add_method_name('children').should == 'add_child'
      subject.child_add_method_name('fliers').should == 'add_flier'
      subject.child_add_method_name('octopi').should == 'add_octopus'
    end
  end
  
  describe '#child_collection_method_name' do
    it 'should pluralize the `child_name` given' do
      subject.child_collection_method_name('entity').should == 'entities'
      subject.child_collection_method_name('child').should == 'children'
      subject.child_collection_method_name('flier').should == 'fliers'
      subject.child_collection_method_name('octopus').should == 'octopi'
    end
  end
  
  describe '#child_collection_instance_variable_name' do
    it 'should call #child_collection_method_name with the `child_name` given' do
      subject.should_receive(:child_collection_method_name).with('entity')
      subject.child_collection_instance_variable_name('entity')
    end
    
    it 'should prepend "@" to the result' do
      subject.child_collection_instance_variable_name('entity').should start_with('@')
    end
  end
  
  describe '#child_create_collection_object' do
    it 'should return a new Array instance' do
      subject.child_create_collection_object.should == []
    end
  end
  
  describe '#child_instantiate_method_name' do
    it 'should singularize the `child_name` given and prepend "instantiate_"' do
      subject.child_instantiate_method_name('entities').should == 'instantiate_entity'
      subject.child_instantiate_method_name('entity').should == 'instantiate_entity'
      subject.child_instantiate_method_name('children').should == 'instantiate_child'
      subject.child_instantiate_method_name('fliers').should == 'instantiate_flier'
      subject.child_instantiate_method_name('octopi').should == 'instantiate_octopus'
    end
  end
  
end

describe ParentSubclassed do
  subject { ParentSubclassed }
  
  it_behaves_like 'a parent class'
end

describe ParentIncluded do
  subject { ParentIncluded }
  
  it_behaves_like 'a parent class'
end

describe ParentExtended do
  subject { ParentExtended }
  
  it_behaves_like 'a parent class'
end
