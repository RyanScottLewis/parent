# Parent

Give your object instances some paternity!

## Install

### Bundler: `gem 'parent'`

### RubyGems: `gem install parent`

## Usage

### Defining Parents

You can define an Object as a Parent by subclassing `Parent` or by including/extending `Parent::Base`.

```ruby
class ParentA < Parent
end

class ParentB
  include Parent::Base
end

class ParentC
  extend Parent::Base
end
```

### Defining Child Collections

An object that is defined as a `Parent` can have many collections of children objects.  
To define a collection, you simply use the `def_child` class method.

```ruby
require 'parent'

class User < Struct.new(:name); end

class Group < Parent
  def_child User
end
```

This will define the `users` and `add_user` instance methods on the `Group` class:

```ruby
group = Group.new
group.add_user 'John Doe'

p group.users  # => [ #<User:0x12eba98 @name="John Doe"> ]
```

You can use a different name for the children collection by giving a Symbol/String with a `:class` option:

```ruby
require 'parent'

class User < Struct.new(:name); end

class Group < Parent
  def_child :people, class: User
end

group = Group.new
group.add_person 'John Doe'

p group.people  # => [ #<User:0x12eba98 @name="John Doe"> ]
```

### Customizing

After an object is defined as as `Parent`, the way methods/instance variables are named, how the collection object is instantiated,
and how a child is retrieved from it's collection can all be customized both globally throughout all instances/subclasses of the `Parent`
class and locally for each defined child.

#### "Add" Method Name

##### Globally

> FILE: examples/change_add_method_name_globally.rb

Override the `child_add_method_name` class method to customize how the "add methods" are named for all child collections:

```ruby
require 'parent'

class User < Struct.new(:name); end
class Element < Struct.new(:name); end

class Group < Parent
  def self.child_add_method_name(child_name)
    "create_#{child_name.singularize}"
  end
  
  def_child User
  def_child Element
end

group = Group.new
group.create_user 'John Doe'      # Notice how both the 'user' and 'element'
group.create_element 'My Element' # child collections now use the 'create_' helper

p group.users  # => [ #<User:0x12eba98 @name="John Doe"> ]
p group.elements  # => [ #<Element:0x0eb1a52 @name="My Element"> ]
```

##### Per-Collection

Use the `:add_method_name` option to customize how the "add method" will be defined for a single child collection.
The value of the option must be an object that responds to `call`, such as a Proc:

```ruby
require 'parent'

class User < Struct.new(:name); end
class Element < Struct.new(:name); end

class Group < Parent
  def_child User, add_method_name: Proc.new { |child_name| "create_#{child_name.singularize}" }
  def_child Element
end

group = Group.new
group.create_user 'John Doe'
group.add_element 'My Element

p group.users  # => [ #<User:0x12eba98 @name="John Doe"> ]
```

## Contributing

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright © 2013 Ryan Scott Lewis <ryan@rynet.us>.

The MIT License (MIT) - See LICENSE for further details.