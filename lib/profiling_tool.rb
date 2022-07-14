require 'ruby-prof'

# You can use this class in your console. For example
#   p = ProfilingTool.new(app, 'http://localhost:3000/api/v1/posts/search?q=from&page[size]=50', 'Bearer aaa')
#   p.profiled_request
# this will profile whole application stack and save file in your tmp/benchmarking folder
# You can also use +request+ method just to see the output for example:
#
#   p.request
#   p.response.body
#   p.response.cookies # and so on
#
# Here's manual for reading profiler report: http://ruby-prof.rubyforge.org/graph.txt
class ProfilingTool
  attr_accessor :response, :app, :url, :token

  def initialize(app, url, token)
    @app = app
    @url = url
    @token = token
  end

  def request
    app.get(url, headers: { 'Authorization' => token })
    @response = app.response
    Rails.logger.debug app.html_document.root.to_s
  end

  # use this in production env or other env where you have: config.cache_classes = true
  def profiled_request
    # Profile the code
    RubyProf.start
    app.get(url, headers: { 'Authorization' => token })
    results = RubyProf.stop
    @response = app.response
    save_profiling_results(results, url)
  end

  private

  def save_profiling_results(results, url)
    folder = Rails.root.join("tmp/benchmarking/#{url}")

    File.open "#{folder}/profile-graph.html", 'w+' do |file|
      RubyProf::GraphHtmlPrinter.new(results).print(file)
    end

    File.open "#{folder}/profile-flat.txt", 'w+' do |file|
      RubyProf::FlatPrinter.new(results).print(file)
    end

    RubyProf::CallTreePrinter.new(results).print(path: "#{folder}/profile-tree/", profile: 'callgrind')

    File.open "#{folder}/profile-stack.html", 'w+' do |file|
      RubyProf::CallStackPrinter.new(results).print(file)
    end
  end
end
