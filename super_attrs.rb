class ARBase
  def self.already_built_attr_methods?
    @already_built_attr_methods
  end
  def method_missing name, *args
    unless self.class.already_built_attr_methods?
      self.class.build_attr_methods
      #try it again
      self.send(name, *args)
    else
      #let the real method missing handle this
      super(name, *args)
    end
  end
 
  def self.build_attr_methods
    #don't want to try this more than once
    return if already_built_attr_methods?
    #so columns will be available in the following blocks
    columns = @columns
    @attr_methods.module_eval do
 
      #everything lives in a central attributes hash
      define_method :attributes do
        @attributes ||= {}
      end
 
      #make the getter and setter methods for all the attributes
      columns.each do |name|
        define_method(name) { attributes[name] }
        define_method("#{name}=") { |val| attributes[name] = val }
      end
    end
    @already_built_attr_methods = true
  end
 
  def self.inherited child
    #give every model class a new module for it's attribute methods
    child.instance_eval do
      @attr_methods = Module.new {}
      include @attr_methods
    end
  end
end
 
class Cat < ARBase
  @columns = [:name, :owner_id]
  def name
    "#{super} the cat!"
  end
end
