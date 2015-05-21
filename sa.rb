class ARBase
  # def method_missing(name, *args, &blk)
  #   if(self.class.attribute_methods_defined?)
  #     super(name, *args, &blk)
  #   else
  #     self.class.define_attribute_methods
  #     self.send(name, *args, &blk)
  #   end
  # end
  #
  def initialize
    self.class.define_attribute_methods
  end

  def self.attribute_methods_defined?
    @attribute_methods_defined
  end

  def self.define_attribute_methods
    return if attribute_methods_defined?
    @attribute_methods_defined = true

    columns = @columns
    @attr_methods.module_eval do 
      define_method(:attributes) do
        @attributes ||= {}
      end

      columns.each do |name|
        define_method(name) do
          attributes[name]
        end
        define_method("#{name}=") do |val|
          attributes[name] = val
        end
      end
    end
  end

  def self.inherited(child)
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
