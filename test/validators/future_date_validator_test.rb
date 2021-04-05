require 'test_helper'

class FutureDateValidatable
  include ActiveModel::Validations
  attr_accessor :expiration_date

  validates :expiration_date, future_date: true
end

class FutureDateValidatorTest < ActiveSupport::TestCase
  def setup
    @obj = FutureDateValidatable.new
  end

  test 'when the date is before the current date should be invalid' do
    @obj.expiration_date = 1.day.ago

    refute @obj.valid?
  end

  test 'when the date is before the current date adds an error' do
    @obj.expiration_date = 1.day.ago

    @obj.valid?
    assert_includes @obj.errors.attribute_names, :expiration_date
  end

  test 'when the date is igual the current date should be invalid' do
    @obj.expiration_date = Time.zone.now

    refute @obj.valid?
  end

  test 'when the date is igual the current date adds an error' do
    @obj.expiration_date = Time.zone.now
    @obj.valid?

    assert_includes @obj.errors.attribute_names, :expiration_date
  end

  test 'should be valid' do
    @obj.expiration_date = Time.zone.tomorrow + 1.day

    assert @obj.valid?
  end
end
