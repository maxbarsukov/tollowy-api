# frozen_string_literal: true

class Validatable
  include ActiveModel::Validations

  attr_accessor :password

  validates :password, password_format: true
end

describe PasswordFormatValidator do
  subject(:model) { Validatable.new }

  it 'is valid when model is valid' do
    model.password = 'Aa1111'
    expect(model).to be_valid
  end

  context 'when model is invalid' do
    it 'is invalid with lower than 6 characters' do
      model.password = 'Aa'
      expect(model).not_to be_valid
    end

    it 'is invalid without latin chars' do
      model.password = '111111'
      expect(model).not_to be_valid
    end

    it 'is invalid without uppercase character' do
      model.password = 'aaa111'
      expect(model).not_to be_valid
    end

    it 'is invalid without lowercase character' do
      model.password = 'AAA111'
      expect(model).not_to be_valid
    end

    it 'is invalid without a number character' do
      model.password = 'AAAaaa'
      expect(model).not_to be_valid
    end
  end
end
