module StringCheckBase64
  refine String do
    def base64?
      is_a?(String) && Base64.strict_encode64(Base64.decode64(self)) == self
    end
  end
end
