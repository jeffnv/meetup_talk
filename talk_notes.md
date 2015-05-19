# What's the deal with `super`?

* realized when student asked a question about usage of super in user
  model, they knew what it did, but how?
* obviously not from the base class?
* how would we get this behavior? Could also be on a module.
* dynamically defined based on the column names, but where?
* so when ARBase is inherited it inserts a module
* first, what are these methods, what is inside these accessor methods
* not defined on base class, AR base, because we couldn't possibly have
  every defined
