class ARBase
  def self.already_built_attr_methods?
    @already_built_attr_methods
  end

  def method_missing(name, *args)
    if self.class.already_built_attr_methods?
      super(name, *args)
    else
      self.class.generate_attribute_methods
      self.send(name, *args)
    end
  end

  def self.generate_attribute_methods
    return if already_built_attr_methods?
    columns = @columns
    @attr_methods.module_eval do 
      define_method :attributes do 
        @attributes ||= {}
      end
      (columns || []).each do |name|
        define_method(name) do
          attributes[name]
        end
        define_method("#{name}=") do |val|
          attributes[name] = val
        end
      end
    end
    @already_built_attr_methods = true
  end

  def self.inherited(child)
    puts "INHERITED"
    child.instance_eval do
      @attr_methods = Module.new {}
      include @attr_methods
    end
  end
end

class User < ARBase
  @columns = [:name, :password_digest, :session_token]
  def name
    super + "!!!"
  end
end
