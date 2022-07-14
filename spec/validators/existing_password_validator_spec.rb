# frozen_string_literal: true

require 'rails_helper'

describe ExistingPasswordValidator do
  let(:form) { UpdateUserForm.new(user) }
  let(:user) { build(:user, password: 'Qq123456') }

  before do
    form.assign_attributes({ password: 'Qwerty1', current_password: })
    form.validate
  end

  describe 'existing password validation' do
    context 'when current_password is invalid' do
      let(:current_password) { 'Qq1234_56' }

      it 'fails and adds error' do
        expect(form.errors[:current_password]).to include('is incorrect')
      end
    end

    context 'when current_password is valid' do
      let(:current_password) { 'Qq123456' }

      it 'succeeds' do
        expect(form.errors).to be_empty
      end
    end
  end
end
