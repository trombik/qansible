#!/usr/bin/env ruby
require 'ansible_init'

AnsibleInit.new(
  :role_name => ARGV[0]
).run
