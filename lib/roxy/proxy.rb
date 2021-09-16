module Roxy

  # The very simple proxy class that provides a basic pass-through
  # mechanism between the proxy owner and the proxy target.
  class Proxy < BasicObject
    def initialize(owner, options, args, &block)
      @owner = owner
      @target = options[:to]
      @args = args
      
      # Adorn with user-provided proxy methods
      [options[:extend]].flatten.each { |ext| ext.send(:extend_object, self) } if options[:extend]
      instance_eval &block if ::Kernel.block_given? 
    end
      
    def proxy_owner; @owner; end
    def proxy_target
      if @target.is_a?(::Proc)
        @target.call(@owner)
      elsif @target.is_a?(::UnboundMethod)
        bound_method = @target.bind(proxy_owner)
        bound_method.arity == 0 ? bound_method.call : bound_method.call(*@args)
      else
        @target
      end
    end
  
    # Delegate all method calls we don't know about to target object
    def method_missing(sym, *args, &block)
      proxy_target.__send__(sym, *args, &block)
    end
  end
end
