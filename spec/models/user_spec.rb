# frozen_string_literal: true

require 'rails_helper'

describe User, type: :model do
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:username) }

  it { is_expected.to have_many(:events) }
  it { is_expected.to have_many(:refresh_tokens) }
  it { is_expected.to have_many(:possession_tokens) }
end
