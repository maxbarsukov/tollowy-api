class Response::Github::UserResponseDecorator < ApplicationDecorator
  delegate_all

  def username
    username_variants.each do |name|
      return name unless User.exists?(username: name)
    end
  end

  def bio
    object.bio.present? ? object.bio[0...1000] : nil
  end

  def blog
    return nil if object.blog.blank?

    blog_url = object.blog.start_with?('http://', 'https://') ? object.blog : "https://#{object.blog}"
    (blog_url =~ /\A#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}\z/).present? ? blog_url : nil
  end

  def location
    object.location.present? ? object.location[0...200] : nil
  end

  def password
    return @password if defined? @password

    @password ||= "GH#{SecureRandom.hex(10)}"
  end

  private

  # Multiple variants of username if user with Github login already exists in Followy
  def username_variants
    gh_login = transform_login(object.login)
    [
      gh_login[0...25],
      "#{gh_login[0...23]}#{rand.to_s[2..3]}",
      "#{gh_login[0...21]}#{rand.to_s[2..5]}",
      "#{gh_login[0...19]}#{rand.to_s[2..7]}",
      "#{gh_login[0...17]}#{rand.to_s[2..9]}"
    ]
  end

  def transform_login(login)
    login = login.tr('-', '_')
    return login if login.length >= 5
    return login * 2 if login.length >= 3
    return login * 3 if login.length == 2

    login * 5
  end
end
