class RequestStub
  attr_accessor :remote_ip

  def initialize(remote_ip)
    @remote_ip = remote_ip
  end
end
