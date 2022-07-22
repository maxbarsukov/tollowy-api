# == Schema Information
#
# Table name: providers
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  uid        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_providers_on_name_and_uid  (name,uid) UNIQUE
#  index_providers_on_user_id       (user_id)
#

require 'rails_helper'

describe Provider, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:uid) }
  it { is_expected.to belong_to(:user) }
end
