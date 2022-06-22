# frozen_string_literal: true

class ApplicationUploader < CarrierWave::Uploader::Base
  include CarrierWave::BombShelter # limits size to 4096x4096
  include CarrierWave::MiniMagick

  PROTECTED_METHODS = %i[filename cache_dir store_dir].freeze
  EXTENSION_ALLOWLIST = %w[jpg jpeg jpe gif png].freeze
  FRAME_MAX = 500
  FRAME_STRIP_MAX = 150

  process :validate_frame_count
  process :strip_exif

  storage :file

  before :cache, :protect_from_path_traversal!

  def store_dir
    # eg. uploads/user/profile_image/1/e481b7ee.jpg
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_allowlist
    EXTENSION_ALLOWLIST
  end

  def size_range
    1..(25.megabytes)
  end

  protected

  # strip EXIF (and GPS) data
  def strip_exif
    # There will be no exif data for an SVG
    return if file.content_type.include?('svg')

    manipulate! do |image|
      image.strip unless image.frames.count > FRAME_STRIP_MAX
      image = yield(image) if block_given?
      image
    end
  end

  def validate_frame_count
    begin
      return unless MiniMagick::Image.new(file.path).frames.count > FRAME_MAX
    rescue Timeout::Error
      raise CarrierWave::IntegrityError, I18n.t('uploaders.application_uploader.timeout')
    end

    raise CarrierWave::IntegrityError, I18n.t('uploaders.application_uploader.too_many_frames', frame_max: FRAME_MAX)
  end

  private

  # Protect against path traversal attacks
  # This takes a list of methods to test for path traversal, e.g. ../../
  # and checks each of them. This uses `.send` so that any potential errors
  # don't block the entire set from being tested.
  #
  # @param [CarrierWave::SanitizedFile]
  # @return [Nil]
  # @raise [Application::Utils::PathTraversalAttackError]
  def protect_from_path_traversal!(_file)
    PROTECTED_METHODS.each do |method|
      Application::Utils.check_path_traversal!(send(method))
    end
  end
end
