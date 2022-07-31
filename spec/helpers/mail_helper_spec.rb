# frozen_string_literal: true

require 'rails_helper'

describe MailHelper do
  describe '#logo_path' do
    it 'returns full path to logo image' do
      expect(helper.logo_path).to end_with('/static/images/logo.png')
    end
  end
end
