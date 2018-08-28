class User < ActiveRecord::Base
  def with_confirm(*fields)
    return if fields.empty?
    fields.map(&:to_sym).each {|field| instance_variable_set "@with_confirm_#{field}", true }
    class_eval do
      attr_accessor *fields.map {|field| "#{field}_confirmation".to_sym }
      attr_reader *fields.map {|field| field.to_sym }.reject {|field| field != :password}
    end

    fields.each do |field|
      confirm = "confirm_#{field}".to_sym
      define_singleton_method confirm do
        if instance_variable_get "@with_#{confirm}"
          case field
          when :password
            return if @password.nil?
            unless authenticate @password_confirmation
              errors.add :password_confirmation, "Passwords don't match"
            end
          else
            actual = self.send field
            return if actual.nil?
            confirmation = instance_variable_get "@#{field}_confirmation"
            unless actual == confirmation
              errors.add "#{field}_confirmation", "#{field.to_s.pluralize.capitalize} don't match"
            end
          end
        end
      end

      class_eval do
        private confirm
        validate confirm
      end
    end
    self
  end
end