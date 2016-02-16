Gem::Specification.new do |spec|
  spec.name          = "lita-link-library"
  spec.version       = "0.0.1"
  spec.authors       = ["Tudor Munteanu"]
  spec.email         = ["the.tudor.munteanu@gmail.com"]
  spec.description   = %q{A Lita handler that allows you manage a link library.}
  spec.summary       = %q{A Lita handler that allows you manage a link library.}
  spec.homepage      = "https://github.com/sijiton/lita-link-library"
  spec.license       = "[MIT]"
  spec.metadata      = { "lita_plugin_type" => "handler" }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", ">= 2.7"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "coveralls"
end
