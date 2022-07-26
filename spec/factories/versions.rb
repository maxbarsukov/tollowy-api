# == Schema Information
#
# Table name: versions
#
#  id         :bigint           not null, primary key
#  for_role   :string           default("all"), not null
#  link       :string           not null
#  size       :integer          not null
#  v          :string           not null
#  whats_new  :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_versions_on_v  (v) UNIQUE
#
FactoryBot.define do
  factory :version do
    sequence(:v) { |n| "#{n}.#{n}.#{n}" }
    for_role { 'all' }
    link { "https://raw.followy.ru/v/#{v}" }
    size { rand(1000..40_000) }
    whats_new { Faker::Lorem.paragraph(sentence_count: 2) }
  end
end
