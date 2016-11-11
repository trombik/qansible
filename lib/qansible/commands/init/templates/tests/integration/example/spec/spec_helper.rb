require 'infrataster/rspec'
require 'capybara'

ENV['VAGRANT_CWD'] = File.dirname(__FILE__)
ENV['LANG'] = 'C'

if ENV['JENKINS_HOME']
  # XXX "bundle exec vagrant" fails to load.
  # https://github.com/bundler/bundler/issues/4602
  #
  # > bundle exec vagrant --version
  # bundler: failed to load command: vagrant (/usr/local/bin/vagrant)
  # Gem::Exception: can't find executable vagrant
  #   /usr/local/lib/ruby/gems/2.2/gems/bundler-1.12.1/lib/bundler/rubygems_integration.rb:373:in `block in replace_bin_path'
  #   /usr/local/lib/ruby/gems/2.2/gems/bundler-1.12.1/lib/bundler/rubygems_integration.rb:387:in `block in replace_bin_path'
  #   /usr/local/bin/vagrant:23:in `<top (required)>'
  #
  # this causes "vagrant ssh-config" to fail, invoked in a spec file, i.e. when
  # you need to ssh to a vagrant host.
  #
  # include the path of bin to vagrant
  vagrant_real_path = `pkg info -l vagrant | grep -v '/usr/local/bin/vagrant' | grep -E 'bin\/vagrant$'| sed -e 's/^[[:space:]]*//'`
  vagrant_bin_dir = File.dirname(vagrant_real_path)
  ENV['PATH'] = "#{vagrant_bin_dir}:#{ENV['PATH']}"
end

Infrataster::Server.define(
  :client1,
  '192.168.21.100',
  vagrant: true
)
Infrataster::Server.define(
  :server1,
  '192.168.21.200',
  vagrant: true
)

def fetch(uri_str, limit = 10)
  raise ArgumentError, 'too many HTTP redirects' if limit == 0
  response = Net::HTTP.get_response(URI(uri_str))
  case response
  when Net::HTTPSuccess then
    response
  when Net::HTTPRedirection then
    location = response['location']
    warn "redirected to #{location}"
    fetch(location, limit - 1)
  else
    raise "HTTP response is not success nor redirect (value: #{response.value})"
  end
end

def retry_and_sleep(options = {}, &block)
  opts = {
    :tries => 60,
    :sec => 10,
    :on => [ Exception ],
    :verbose => false
  }.merge(options)
  tries, sec, on, verbose = opts[:tries], opts[:sec], opts[:on], opts[:verbose]
  i = 1
  begin
    yield
  rescue *on => e
    warn "rescue an excpetion %s" % [ e.class ] if verbose
    warn e.message if verbose
    if (tries -= 1) > 0
      warn "retrying (remaining: %d)" % [ tries ]
      warn "sleeping %d sec" % [ sec ] if verbose
      sleep sec
      i += 1
      retry
    end
  end
end

require 'shellwords'
class Vagrant

  def initialize
    @status # Process::Status
    @out
    @err
  end

  def up(server)
    execute('up', '', server)
  end

  def boot(server)
    execute('up', '--no-provision', server)
  end

  def provision(server)
    execute('provision', '', server)
  end

  def destroy(server)
    execute('destroy', '--force', server)
  end

  def execute(command, opt, server)
    begin
      command = "vagrant #{Shellwords.escape(command)}" + ' '
      command += "#{Shellwords.escape(opt)}" + ' ' if not opt.empty?
      command += "#{Shellwords.escape(server)}"
      @out, @err, @status = Open3.capture3(command)
    rescue SystemCallError => e
      @status = e
    end
    status
  end

  def status
    @status
  end

  def stdout
    @out
  end

  def stdout_lines
    @out.split("\n").to_a
  end

  def stderr
    @err
  end

  def stderr_lines
    @err.split("\n").to_a
  end

  def status
    @status
  end

  def success?
    return  false if @success.nil?
    return false if @status.is_a?(Exception)
    @status.success?
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
