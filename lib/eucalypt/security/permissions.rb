require 'active_record'
require 'active_support/core_ext'

Eucalypt.glob('app', '{policies}', '*.rb') do |file|
  policy_name        = File.basename file, '.rb'
  policy_constant    = policy_name.camelize.constantize
  resource_name      = policy_name.gsub '_policy', ''
  roles_name         = "#{resource_name}_roles"
  role_constant_name = roles_name.singularize.camelize
  role_constant      = role_constant_name.constantize

  if ActiveRecord::Base.connection.table_exists? roles_name
    role_constant.pluck(:permission).each do |permission|
      policy_constant.define_method "#{permission}?" do
        role_constant.find_by(permission: permission).send(user.role.send resource_name)
      end
    end
  end
end