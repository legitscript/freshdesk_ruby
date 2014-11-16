Bundler.require(:test)

require 'webmock/rspec'

WebMock.disable_net_connect!

lib_files = File.expand_path(File.join('lib', '*.rb'))
Dir.glob(lib_files).each { |f| require f }
