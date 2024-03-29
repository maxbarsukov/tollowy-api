class Response::Vk::UserGetResponseDecorator < ApplicationDecorator
  delegate_all

  def username
    username_variants.each do |name|
      return name unless User.exists?(username: name)
    end
  end

  # Multiple variants of username
  # if user with screen_name already exists in Followy
  def username_variants # rubocop:disable Metrics/AbcSize
    tr_first_name = transliterate(first_name)[0...12]
    tr_last_name = transliterate(last_name)[0...12]
    scr_name = transform_screen_name(screen_name)
    [
      scr_name[0...25],
      "#{tr_first_name}#{tr_last_name}",
      "#{tr_last_name}#{tr_first_name}",
      "#{scr_name[0...23]}#{rand.to_s[2..3]}",
      "#{scr_name[0...21]}#{rand.to_s[2..5]}",
      "#{scr_name[0...19]}#{rand.to_s[2..7]}"
    ]
  end

  def bio
    return "#{status}. #{about}"[0...1000] if status.present? && about.present?
    return about[0...1000] if about.present?

    status.present? ? status[0...1000] : nil
  end

  def blog
    return nil if site.nil?

    sites = URI.extract(site, /http(s)?/)
    sites.empty? ? nil : sites.find { |x| x.length <= 200 }
  end

  def location
    return "#{country[:title]}, #{city[:title]}"[0...200] if country.present? && city.present?

    country[:title][0...200] if country.present?
  end

  def password
    return @password if defined? @password

    @password ||= "VK#{SecureRandom.hex(10)}"
  end

  private

  def transform_screen_name(screen_name)
    name = transliterate(screen_name)
    name *= 5 if name.length < 5
    name
  end

  def transliterate(str)
    str.tr('ь', '').tr('ъ', '').tr('Ь', '').tr('Ъ', '').tr(' ', '_').tr('-', '_').to_lat
  end
end
