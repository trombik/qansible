# coding: utf-8
require File.expand_path('../lib/qansible/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "qansible"
  spec.version       = Qansible::VERSION
  spec.authors       = ["Tomoyuki Sakurai"]
  spec.email         = ["tomoyukis@reallyenglish.com"]

  spec.summary       = %q{Inspect ansible role and complain}
  spec.description   = %q{}
  spec.homepage      = "https://github.com/trombik/%s" % [ spec.name ]
  spec.licenses      = [ 'ISC' ]

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
