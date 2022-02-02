require 'rails_helper'

RSpec.describe Participant, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:room) }
end
