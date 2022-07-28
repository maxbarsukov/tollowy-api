require 'rails_helper'

describe Auth::Refresh do
  let(:interactor) { described_class.new }

  it { expect(interactor).to be_kind_of(Interactor::Organizer) }

  it {
    expect(described_class.organized).to eq(
      [
        Auth::Refresh::ValidateRefreshToken,
        Auth::CreateAccessToken,
        Auth::CreateRefreshToken
      ]
    )
  }
end
