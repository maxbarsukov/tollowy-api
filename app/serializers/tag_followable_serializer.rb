class TagFollowableSerializer < ApplicationSerializer
  set_type :tag

  attributes :name,
             :created_at,
             :updated_at,
             :followers_count,
             :taggings_count

  meta do |_tag, params|
    { followed_at: params[:followed_at] }
  end
end
