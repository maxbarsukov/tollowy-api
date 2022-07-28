# frozen_string_literal: true

# == Schema Information
#
# Table name: roles
#
#  id            :bigint           not null, primary key
#  name          :string
#  resource_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  resource_id   :bigint
#
# Indexes
#
#  index_roles_on_name_and_resource_type_and_resource_id  (name,resource_type,resource_id)
#  index_roles_on_resource                                (resource_type,resource_id)
#
require 'rails_helper'

describe Role, type: :model do
  before do
    roles = []
    Role::MAIN_ROLES.each do |role_name|
      roles << described_class.new(name: role_name)
    end
    described_class.import(roles)
  end

  it { is_expected.to have_and_belong_to_many(:users).join_table(:users_roles) }
  it { is_expected.to belong_to(:resource).optional }

  it { is_expected.to validate_inclusion_of(:name).in_array(Role::MAIN_ROLES) }

  describe '.value_for' do
    context 'when arg is a number' do
      it 'returns same number' do
        expect(described_class.value_for(30)).to be(30)
      end

      it 'raises error if no such role value' do
        expect { described_class.value_for(1111) }
          .to raise_error(Roles::UnexpectedRoleTypeError)
      end
    end

    context 'when arg is a string' do
      it 'returns value for role name string' do
        expect(described_class.value_for('admin')).to be(50)
      end

      it 'raises error if no such role string' do
        expect { described_class.value_for('no_such_role') }
          .to raise_error(Roles::UndefinedRoleTypeError)
      end
    end

    context 'when arg is a symbol' do
      it 'returns value for role name symbol' do
        expect(described_class.value_for(:admin)).to be(50)
      end

      it 'raises error if no such role symbol' do
        expect { described_class.value_for('no_such_role') }
          .to raise_error(Roles::UndefinedRoleTypeError)
      end
    end

    context 'when arg is a role' do
      it 'returns value for role' do
        expect(described_class.value_for(described_class.find_by(name: :user))).to be(0)
      end
    end

    context 'when arg is undefined' do
      it 'raises error' do
        expect { described_class.value_for({}) }
          .to raise_error(Roles::UnexpectedRoleTypeError)
      end
    end
  end

  describe '.symbol_name_for' do
    context 'when arg is a number' do
      it 'returns name for current value' do
        expect(described_class.symbol_name_for(50)).to be(:admin)
      end
    end

    context 'when arg is a symbol or string' do
      it 'returns same symbol' do
        expect(described_class.symbol_name_for(:admin)).to be(:admin)
        expect(described_class.symbol_name_for('admin')).to be(:admin)
      end
    end

    context 'when arg is a role' do
      it 'returns name for role' do
        expect(described_class.symbol_name_for(described_class.find_by(name: :user))).to be(:user)
      end
    end

    context 'when arg is undefined' do
      it 'raises error' do
        expect { described_class.symbol_name_for({}) }
          .to raise_error(Roles::UnexpectedRoleTypeError)
      end
    end
  end
end
