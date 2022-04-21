require 'generator_spec'

describe SwaggerSchema, type: :generator do
  destination File.expand_path('../../../tmp/specs', __dir__)

  context 'with valid argument' do
    arguments %w[auth/sign_out --type=response]

    before do
      prepare_destination
      run_generator
    end

    specify do
      expect(destination_root).to(have_structure do
        directory 'spec' do
          directory 'swagger' do
            directory 'schemas' do
              directory 'response' do
                directory 'auth' do
                  file 'sign_out.rb' do
                    contains 'class Schemas::Response::Auth::SignOut < Schemas::Base'
                    contains 'def self.data'
                    contains "title: 'Auth::SignOut'"
                  end
                end
              end
            end
          end
        end
      end)
    end
  end
end
