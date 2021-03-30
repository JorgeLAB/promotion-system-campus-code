class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@iugu.com.br\z/i
      message = options[:message] || :email
      record.errors.add(attribute, message)
    end
  end
end

