require 'rails_helper'

describe Response::Vk::UserGetResponseDecorator do
  subject(:response_decorator) { described_class }

  let!(:default_response) do
    {
      id: '12',
      screen_name: 'maxbarsukov',
      first_name: 'Max',
      last_name: 'Barsukov',
      site: 'https://mysite.com',
      status: 'Hello',
      about: 'Its me'
    }
  end

  it 'is expected to inherit Draper::Decorator' do
    expect(described_class).to be < Draper::Decorator
  end

  describe '#location' do
    let(:user_response) do
      response = { response: [default_response.merge(add_data)] }
      Response::Vk::UserGetResponse.new(response)
    end

    let(:decorator) { described_class.new(user_response) }

    context 'with country and city' do
      let(:add_data) { { country: { title: 'Russia' }, city: { title: 'Moscow' } } }

      it 'returns location' do
        expect(decorator.location).to eq('Russia, Moscow')
      end
    end

    context 'with only country' do
      let(:add_data) { { country: { title: 'Russia' } } }

      it 'returns location' do
        expect(decorator.location).to eq('Russia')
      end
    end

    context 'without country and city' do
      let(:add_data) { {} }

      it 'returns location' do
        expect(decorator.location).to be_nil
      end
    end
  end

  describe '#transliterate' do
    let(:user_response) do
      response = { response: [default_response] }
      Response::Vk::UserGetResponse.new(response)
    end

    it 'transliterates a string' do
      decorator = described_class.new(user_response)
      expect(decorator.send(:transliterate, 'привет-это_же бъБЪрьРЬ  хаха')).to eq('privet_eto_zhe_bBrR__haha')
    end
  end

  describe '#transform_screen_name' do
    let(:user_response) do
      response = { response: [default_response] }
      Response::Vk::UserGetResponse.new(response)
    end

    it 'transliterates a string' do
      decorator = described_class.new(user_response)
      expect(decorator.send(:transform_screen_name, 'name')).to eq('name' * 5)
      expect(decorator.send(:transform_screen_name, 'n')).to eq('nnnnn')
      expect(decorator.send(:transform_screen_name, 'my-na me')).to eq('my_na_me')
    end
  end
end
