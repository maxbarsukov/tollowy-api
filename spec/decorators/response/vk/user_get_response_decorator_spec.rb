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

  describe '#bio' do
    let(:user_response) do
      response = { response: [default_response.merge(add_data)] }
      Response::Vk::UserGetResponse.new(response)
    end

    let(:decorator) { described_class.new(user_response) }

    context 'with status and bio' do
      let(:add_data) { { status: 'Hello', about: 'Its me' } }

      it 'returns bio' do
        expect(decorator.bio).to eq('Hello. Its me')
      end
    end

    context 'with only about' do
      let(:add_data) { { status: '', about: 'Its me' } }

      it 'returns bio' do
        expect(decorator.bio).to eq('Its me')
      end
    end

    context 'with only status' do
      let(:add_data) { { status: 'Hello', about: '' } }

      it 'returns bio' do
        expect(decorator.bio).to eq('Hello')
      end
    end

    context 'without about and status' do
      let(:add_data) { { about: '', status: '' } }

      it 'returns nil' do
        expect(decorator.bio).to be_nil
      end
    end
  end

  describe '#blog' do
    let(:user_response) do
      response = { response: [default_response.merge(add_data)] }
      Response::Vk::UserGetResponse.new(response)
    end

    let(:decorator) { described_class.new(user_response) }

    context 'with many links in sites text' do
      let(:add_data) { { site: 'Hello https://example.com, https://hey.com <- my sites' } }

      it 'returns first blog' do
        expect(decorator.blog).to eq('https://example.com')
      end
    end

    context 'with only one link in sites text' do
      let(:add_data) { { site: 'Hello https://example.com <- my site' } }

      it 'returns blog' do
        expect(decorator.blog).to eq('https://example.com')
      end
    end

    context 'with no links text in sites' do
      let(:add_data) { { site: 'there is no links' } }

      it 'returns nil' do
        expect(decorator.blog).to be_nil
      end
    end

    context 'without site' do
      let(:add_data) { { site: nil } }

      it 'returns nil' do
        expect(decorator.blog).to be_nil
      end
    end
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
