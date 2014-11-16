module Freshdesk
  #
  class Base
    def initialize(attributes)
      attributes.each do |(attr, value)|
        set_variable(attr, value) unless respond_to?(attr)
      end
    end

    def set_variable(attr, value)
      ivar = "@#{attr}"
      instance_variable_set(ivar, value)
      instance_eval "def #{attr}; @#{attr}; end"
    end
  end
end
