# What's the deal with `super`?

### Context
* was explaining [this user model][user_model]
* one very clever student noticed `super` in `password_digest` getter
  (line 23)
* his question was 'how' is `super` working here, but I answered 'why'
* he clarified that he understood what it was doing, but now how
* so I answered why again
* he clarified once more and I realized I had always just accepted it
* yet another time for me to look at the code and say "I don't know how
  that works", in front of 50 people
* we tolerate a lot of magic in Rails
* so I decided to try and make a model

### The Model

#### Defining Accessors Lazily Based on Column Names
* needs to define attribute methods
* should do it lazily, upon method missing is a good enough time
* need to keep track of whether we have built our accessors or not, so
  we don't do it infinity times, use a class instance variable type boolean
* if we haven't built yet, call `self.define_accessors`
* return early if already defined
* also make an attributes method that returns a hash
* iterate over column names, write getters and setters for each using
  `define_method`

#### `super`
* accessors need to be overridable
* can't do it in parent class, other models share it
* can't just do it earlier in the class, redefined methods can't `super`
* module is the way to get this behavior
* when the class is inherited we get a callback, `inherited`, can insert a module
  then, use an instance variable to keep a pointer to this module
* then we write methods inside of the module using `module_eval`
* now we can override these methods and call the original using `super`

## Key Points
* ActiveRecord stores data in a central `attributes` hash
* attribute methods are defined lazily
* previous rails versions defined attribute methods using `method_missing`, 
  the first time they are used (4.0.2)
* now they are defined when the first instance is created (`initialize`
  in the base classe) (4.2.0)
* a module is created and set as an
  instance variable when ActiveRecord::Base is inherited
* when the methods are written they go into this module


## References
* [attribute methods (4.0.2)][methods_4_0_2]
* [attribute methods (4.2.0)][methods_4_2_0]
* [active model core (4.2.0)][core]

[methods_4_0_2]: https://github.com/rails/rails/blob/4-0-stable/activerecord/lib/active_record/attribute_methods.rb
[methods_4_2_0]: https://github.com/rails/rails/blob/4-2-stable/activerecord/lib/active_record/attribute_methods.rb 
[core]: https://github.com/rails/rails/blob/4-2-stable/activerecord/lib/active_record/core.rb
[user_model]: app/models/user.rb
