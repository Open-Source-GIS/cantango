module CanTango
  module PermissionEngine
    module Selector
      class Licenses < Base
        attr_reader :roles, :role_groups

        def initialize subject
          @roles  = subject.roles_list
          @role_groups = subject.role_groups_list
        end

        def valid? permission
          (roles | role_groups).include? permission.to_sym
        end
      end
    end
  end
end

