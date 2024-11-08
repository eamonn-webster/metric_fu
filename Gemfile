# encoding: utf-8
source "https://rubygems.org"

if RUBY_VERSION >= '1.9.3'
  gem "rubocop", platforms: :mri, groups: [:test, :local_development]
  gem "activesupport", "~> 4.2"
  gem 'flog', github: 'eamonn-webster/flog', require: false

  if RUBY_VERSION > '2.3'
    gem "json", ">= 2.0"
  else
    gem "json", "~> 1.7"
  end
  if RUBY_VERSION =~ /^2\.0\..*/
    gem "unparser", "0.2.4"
  elsif RUBY_VERSION =~ /^1\.9\.3.*/
    gem "unparser", "0.2.4"
    gem "json_pure", "2.0.1"
    gem "mime-types", "2.99.3"
    gem "rest-client", "1.8.0"
    gem "addressable", "2.4.0"
    gem "ffi", "1.9.14" # windows support
  end
elsif RUBY_VERSION =~ /^1\.9\.2.*/
  # because of https://github.com/railsbp/rails_best_practices/blob/master/rails_best_practices.gemspec
  gem "activesupport", "~> 3.2"
  # because of https://github.com/troessner/reek/issues/334
  gem "reek", "~> 1.4.0"
  # rbp -> as -> i18n
  gem "i18n", "0.6.11"
  gem "parallel", "= 1.3.3" # 1.3.4 disallows 1.9.2
  gem "unparser", "0.1.5"
  gem "json_pure", "2.0.1"
  gem "mime-types", "2.99.3"
  gem "rest-client", "1.8.0"
  gem "json", "~> 1.7"
  gem "addressable", "2.4.0"
  gem "rainbow", "2.1.0"
  gem "ffi", "1.9.14" # windows support
end

gemspec path: File.expand_path("..", __FILE__)

platform :jruby do
  group :jruby do
    gem "jruby-openssl", "~> 0.9.17"
  end
end

group :test, :local_development  do
  gem "pry"
  gem "pry-nav"
end

# Added by devtools
group :development do
  gem "rake",  "~> 10.1.0"
  gem "yard",  "~> 0.8.7", group: :yard
end
