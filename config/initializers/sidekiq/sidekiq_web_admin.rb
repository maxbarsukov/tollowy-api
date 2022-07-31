module SidekiqWebAdmin
  def self.registered(app)
    app.get('/admin') do
      redirect '/admin'
    end
  end
end
