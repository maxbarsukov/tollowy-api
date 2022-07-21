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
class Provider < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :uid, presence: true, uniqueness: { scope: :name }
end
