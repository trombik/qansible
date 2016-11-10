#!/usr/bin/env ruby
require "ansible_init"

begin
  AnsibleInit.new(
    :role_name => ARGV[0]
  ).run
rescue StandardError => e
  STDERR.puts "%s: %s" % [ e.class, e.message ]
  exit 1
end
