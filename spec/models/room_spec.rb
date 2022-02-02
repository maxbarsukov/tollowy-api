require 'rails_helper'

RSpec.describe Room, type: :model do
  it { is_expected.to have_many(:participants) }
  it { is_expected.to have_many(:messages) }
  it { is_expected.to validate_presence_of(:name) }
end
