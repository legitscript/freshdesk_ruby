module Freshdesk
  #
  class Base
    def initialize(attributes)
      attributes.each do |(attr, value)|
        set_variable(attr, value) unless respond_to?(attr)
      end
    end

    def set_variable(attr, value)
      reader = "attr_reader:#{attr}"
      ivar = "@#{attr}"
      self.class.class_eval(reader)
      instance_variable_set(ivar, value)
    end
  end
end
