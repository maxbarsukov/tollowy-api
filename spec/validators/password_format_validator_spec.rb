# frozen_string_literal: true

class Validatable
  include ActiveModel::Validations

  attr_accessor :password

  validates :password, password_format: true
end

describe PasswordFormatValidator do
  subject(:model) { Validatable.new }

  it 'is valid when model is valid' do
    allow(model).to receive(:password).and_return('Aa1111')
    expect(model).to be_valid
  end

  context 'when model is invalid' do
    it 'is invalid with lower than 6 characters' do
      allow(model).to receive(:password).and_return('Aa')
      expect(model).not_to be_valid
    end

    it 'is invalid without latin chars' do
      allow(model).to receive(:password).and_return('111111')
      expect(model).not_to be_valid
    end

    it 'is invalid without uppercase character' do
      allow(model).to receive(:password).and_return('aaa111')
      expect(model).not_to be_valid
    end

    it 'is invalid without lowercase character' do
      allow(model).to receive(:password).and_return('AAA111')
      expect(model).not_to be_valid
    end

    it 'is invalid without a number character' do
      allow(model).to receive(:password).and_return('AAAaaa')
      expect(model).not_to be_valid
    end
  end
end
