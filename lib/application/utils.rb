# frozen_string_literal: true

module Application::Utils
  module_function

  PathTraversalAttackError = Class.new(StandardError)

  # Ensure that the relative path will not traverse outside the base directory
  # We url decode the path to avoid passing invalid paths forward in url encoded format.
  # Also see https://gitlab.com/gitlab-org/gitlab/-/merge_requests/24223#note_284122580
  # It also checks for ALT_SEPARATOR aka '\' (forward slash)
  def check_path_traversal!(path)
    return unless path.is_a?(String)

    path = decode_path(path)
    path_regex = %r{(\A(\.{1,2})\z|\A\.\.[/\\]|[/\\]\.\.\z|[/\\]\.\.[/\\]|\n)}

    if path.match?(path_regex)
      Rails.logger.warn "Potential path traversal attempt detected, path: #{path}"
      raise PathTraversalAttackError, 'Invalid path'
    end

    path
  end

  def decode_path(encoded_path)
    decoded = CGI.unescape(encoded_path)
    raise StandardError, "path #{encoded_path} is not allowed" if decoded != CGI.unescape(decoded)

    decoded
  end
end
