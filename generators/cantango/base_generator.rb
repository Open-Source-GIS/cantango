module CanTango
  module Generators
    class Base < Rails::Generators::Base
      def self.inherited(subclass)
        subclass.extend ClassMethods
      end

      module ClassMethods
        def can_actions
          [:create, :update, :manage, :read, :access]
        end
      end

      can_actions.each do |action|
        class_eval %{
          class_option :#{action},      :type => :array,     :default => [],  :desc => "Models allowed to #{action}"
        }
      end

      protected

      can_actions.each do |action|
        class_eval %{
          def #{action}
            options[:#{action}]
          end
        }
      end

      def rules_logic
        self.class.can_actions.map do |action|
          send(action).map do |c|
            "can(:#{action}, #{act_model(c)})"
          end.join("\n    ")
        end.join("\n    ")
      end

      def act_model name
        return ':all' if name == 'all'
        name.camelize
      end
    end
  end
end


