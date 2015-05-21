# What's the deal with `super`?

* start by explaining the context, explaining details of how the user
  model works. Explaining validations, password digest, and session
  token
* one very clever student noticed super in password override
* his question was 'how' but I answered 'why'
* he clarified that he understood what it was doing
* so I answered why again
* he clarified and I realized I had always just accepted it
* ps. we hired the guy
* yet another time for me to look at the code and say "i don't know how
  that works", in front of 50 people
* we tolerate a lot of magic
* so I decided to try and make a model

* needs to define accessors
* should do it lazily, do it upon method missing
* need to keep track of whether we have built our accessors or not, so
  we don't do it infinity times
* if we haven't built yet, call `self.define_accessors`
* return early if already defined 
* also make an attributes method that returns a hash
* iterate over column names, write getters and setters for each

* accessors need to be overridable
* can't do it in parent class, other models share it
* can't just do it earlier in the class, redefined methods can't `super`
* module is the way to get this behavior
* when the class is inherited we get a callback, can insert a module
  then, use an instance variable to keep a pointer to this module
* then we write methods inside of the module using `module_eval`


## Key Points
* ActiveRecord stores data in a central `attributes` hash
* used to define attribute methods using method missing, the first time
  they are used (4.0.2)
* now they are defined when the first instance is created (allocate is
  overwritten, also in initialize) (4.2.0)
* a module is created and set as an
  instance variable when ARBase is inherited
* when the methods are written they go into this module

* [attribute methods (4.0.2)][methods_4_0_2]
* [attribute methods (4.2.0)][methods_4_2_0]
* [active model core (4.2.0)][core]

[methods_4_0_2]: https://github.com/rails/rails/blob/4-0-stable/activerecord/lib/active_record/attribute_methods.rb
[methods_4_2_0]: https://github.com/rails/rails/blob/4-2-stable/activerecord/lib/active_record/core.rb
[core]: https://github.com/rails/rails/blob/4-2-stable/activerecord/lib/active_record/attribute_methods.rb 
