describe ApplicationPolicy do
  subject(:app_policy) { described_class }

  before do
    stub_const 'TestPolicy', Class.new(described_class)
    TestPolicy.class_eval do
      def some_action
        require_user_in_good_standing!
      end
    end
  end

  describe '#require_user!' do
    context 'without current user' do
      it 'raises Auth::UserRequiredError' do
        expect do
          app_policy.new(nil, nil)
        end.to raise_error(Auth::UserRequiredError)
      end
    end

    context 'with current user' do
      it 'works normally' do
        expect do
          app_policy.new(create(:user, :with_user_role), nil)
        end.not_to raise_error
      end
    end
  end

  describe '.require_user_in_good_standing!' do
    context 'with banned user' do
      it 'raises Auth::UserSuspendedError' do
        user = create(:user, :with_banned_role)
        expect do
          described_class.require_user_in_good_standing!(user: user)
        end.to raise_error(Auth::UserSuspendedError)
      end
    end

    context 'with normal user' do
      it 'returns true' do
        user = create(:user, :with_user_role)
        expect do
          described_class.require_user_in_good_standing!(user: user)
        end.not_to raise_error
        expect(described_class.require_user_in_good_standing!(user: user)).to be(true)
      end
    end
  end

  describe '#require_user_in_good_standing!' do
    context 'with banned user' do
      it 'raises Auth::UserSuspendedError' do
        user = create(:user, :with_banned_role)
        policy = TestPolicy.new(user, nil)

        expect { policy.some_action }.to raise_error(Auth::UserSuspendedError)
      end
    end

    context 'with normal user' do
      it 'returns true' do
        user = create(:user, :with_user_role)
        policy = TestPolicy.new(user, nil)

        expect { policy.some_action }.not_to raise_error
        expect(policy.some_action).to be(true)
      end
    end
  end

  describe '#scope' do
    it 'returns all records in scope' do
      user = create(:user, :with_user_role)
      policy = TestPolicy.new(user, user)

      expect(policy.scope).to match_array([user])
    end
  end

  describe 'actions' do
    let(:current_user) { create(:user, :with_user_role) }

    describe '#index?' do
      permissions :index? do
        it 'returns false' do
          expect(app_policy).not_to permit(current_user, nil)
        end
      end
    end

    describe '#show?' do
      permissions :show? do
        it 'returns false' do
          expect(app_policy).not_to permit(current_user, nil)
        end
      end
    end

    describe '#create?' do
      permissions :create? do
        it 'returns false' do
          expect(app_policy).not_to permit(current_user, nil)
        end
      end
    end

    describe '#new?' do
      permissions :new? do
        it 'returns false' do
          expect(app_policy).not_to permit(current_user, nil)
        end
      end
    end

    describe '#update?' do
      permissions :update? do
        it 'returns false' do
          expect(app_policy).not_to permit(current_user, nil)
        end
      end
    end

    describe '#edit?' do
      permissions :edit? do
        it 'returns false' do
          expect(app_policy).not_to permit(current_user, nil)
        end
      end
    end

    describe '#destroy?' do
      permissions :destroy? do
        it 'returns false' do
          expect(app_policy).not_to permit(current_user, nil)
        end
      end
    end
  end
end
