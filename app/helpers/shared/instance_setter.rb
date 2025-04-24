module Shared
  module InstanceSetter
    def set_instance_variable(instance,**attributes)
      attributes.each do |key, value|
        instance.send("#{key}=",value) if instance.respond_to?("#{key}=")
      end
    end
  end
end