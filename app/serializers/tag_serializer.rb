class TagSerializer < ApplicationSerializer
  attributes :name,
             :created_at,
             :updated_at,
             :followers_count,
             :taggings_count

  meta do |tag, params|
    { am_i_following: params[:am_i_following] || (params[:signed_in] ? tag.am_i_following : nil) }
  end
end
