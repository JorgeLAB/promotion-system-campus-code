require 'test_helper'

class Validatable
  include ActiveModel::Validations
  attr_accessor :email

  validates :email, email: true
end

class EmailValidatorTest < ActiveSupport::TestCase
  test 'invalided obj for invalid email' do
    obj = Validatable.new
    obj.email = 'mclovin@gmail.com'
    refute obj.valid?
  end

  test 'adds errors for invalid email' do
    obj = Validatable.new
    obj.email = 'mclovin@gmail.com'
    refute_nil obj.errors[:email]
  end

  test 'adds no errors for valid email' do
    obj = Validatable.new
    obj.email = 'mclovin@iugu.com.br'
    assert_empty obj.errors[:email]
    assert obj.valid?
  end
end
