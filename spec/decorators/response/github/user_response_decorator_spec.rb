require 'rails_helper'

describe Response::Github::UserResponseDecorator do
  subject(:response_decorator) { described_class }

  let!(:default_response) do
    {
      id: '12',
      login: 'maxbarsukov',
      email: 'mxa@mail.com',
      blog: 'mysite.com',
      bio: 'My bio!',
      location: 'Russia, Rostov-on-Don'
    }
  end

  it 'is expected to inherit Draper::Decorator' do
    expect(described_class).to be < Draper::Decorator
  end

  describe '#username' do
    let(:user_response) do
      Response::Github::UserResponse.new(default_response)
    end

    let(:decorator) { described_class.new(user_response) }

    it 'returns first username if no users with such username' do
      expect(decorator.username).to eq('maxbarsukov')
    end

    it 'returns most suitable username if users with such username exists' do
      create(:user, username: 'maxbarsukov')
      expect(decorator.username).to start_with('maxbarsukov')
      expect(decorator.username.length).to eq(13)
    end
  end

  describe '#username_variants' do
    let(:user_response) do
      Response::Github::UserResponse.new(default_response)
    end

    let(:decorator) { described_class.new(user_response) }

    it 'returns username variants' do
      expect(decorator.send(:username_variants)[0]).to eq('maxbarsukov')
      expect(decorator.send(:username_variants)[1]).to start_with('maxbarsukov')
      expect(decorator.send(:username_variants)[1].length).to eq(13)
      expect(decorator.send(:username_variants)[2].length).to eq(15)
      expect(decorator.send(:username_variants)[4].length).to eq(19)
    end
  end

  describe '#bio' do
    let(:user_response) do
      Response::Github::UserResponse.new(default_response.merge(add_data))
    end

    let(:decorator) { described_class.new(user_response) }

    context 'with valid bio' do
      let(:add_data) { { bio: 'Hello' } }

      it 'returns bio' do
        expect(decorator.bio).to eq('Hello')
      end
    end

    context 'with invalid bio' do
      let(:add_data) { { bio: 'Hello' * 1000 } }

      it 'cuts bio' do
        expect(decorator.bio).to eq(('Hello' * 1000)[0...1000])
      end
    end

    context 'without bio' do
      let(:add_data) { { bio: nil } }

      it 'returns nil' do
        expect(decorator.bio).to be_nil
      end
    end
  end

  describe '#blog' do
    let(:user_response) do
      Response::Github::UserResponse.new(default_response.merge(add_data))
    end

    let(:decorator) { described_class.new(user_response) }

    context 'with blog starting with http/https' do
      let(:add_data) { { blog: 'https://hey.com' } }

      it 'returns blog' do
        expect(decorator.blog).to eq('https://hey.com')
      end
    end

    context 'with blog not starting with http/https' do
      let(:add_data) { { blog: 'hey.com' } }

      it 'updates blog' do
        expect(decorator.blog).to eq('https://hey.com')
      end
    end

    context 'without site' do
      let(:add_data) { { blog: nil } }

      it 'returns nil' do
        expect(decorator.blog).to be_nil
      end
    end
  end

  describe '#location' do
    let(:user_response) do
      Response::Github::UserResponse.new(default_response.merge(add_data))
    end

    let(:decorator) { described_class.new(user_response) }

    context 'with valid location' do
      let(:add_data) { { location: 'Hello' } }

      it 'returns location' do
        expect(decorator.location).to eq('Hello')
      end
    end

    context 'with invalid location' do
      let(:add_data) { { location: 'Hello' * 1000 } }

      it 'cuts location' do
        expect(decorator.location).to eq(('Hello' * 1000)[0...200])
      end
    end

    context 'without location' do
      let(:add_data) { { location: nil } }

      it 'returns nil' do
        expect(decorator.location).to be_nil
      end
    end
  end

  describe '#transform_login' do
    let(:user_response) do
      Response::Github::UserResponse.new(default_response)
    end

    it 'transliterates a string' do
      decorator = described_class.new(user_response)
      expect(decorator.send(:transform_login, 'name')).to eq('namename')
      expect(decorator.send(:transform_login, 'n')).to eq('nnnnn')
      expect(decorator.send(:transform_login, 'my-name')).to eq('my_name')
      expect(decorator.send(:transform_login, 'my-n')).to eq('my_nmy_n')
    end
  end

  describe '#password' do
    let(:user_response) do
      Response::Github::UserResponse.new(default_response)
    end

    it 'generates password' do
      password = described_class.new(user_response).send(:password)
      expect(password).to start_with('GH')
      expect(password.length).to eq(22)
    end
  end
end
