require 'dry/auto_inject/strategies'
require 'dry/auto_inject/injector'

module Dry
  module AutoInject
    class Builder < BasicObject
      # @api private
      attr_reader :container

      # @api private
      attr_reader :strategies

      def initialize(container, options = {})
        @container = container
        @strategies = options.fetch(:strategies) { Strategies }
      end

      # @api public
      def [](*dependency_names)
        default[*dependency_names]
      end

      def respond_to?(name, include_private = false)
        name == :[] || strategies.key?(name)
      end

      private

      def method_missing(name, *args, &block)
        if strategies.key?(name)
          Injector.new(container, strategies[name])
        else
          super
        end
      end
    end
  end
end
