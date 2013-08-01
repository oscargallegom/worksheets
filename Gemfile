source 'https://rubygems.org'

ruby '1.9.3'

gem 'rails', '3.2.12'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  # gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# added by Olivier

# ruby
# platforms :ruby_19 do
gem 'pg'
gem 'activerecord-postgresql-adapter'
# end

# for jruby
#platforms :jruby do
# gem 'warbler'
# gem 'activerecord-jdbc-adapter'
# gem 'activerecord-jdbcpostgresql-adapter'
#gem 'jdbc-postgres'
#end

gem 'devise'
gem 'cancan'
gem 'will_paginate'
# gem 'jquery-ui-rails'
gem 'breadcrumbs_on_rails'
gem 'recaptcha', :require => 'recaptcha/rails'
gem 'dynamic_form'
# gem 'deep_cloneable', '~> 1.5.2'                 #############################      SQLLite issue with heroku
gem 'nested_form'

# gem 'coffee-rails', '~> 3.2.1'

gem 'savon', '~> 2.2.0'
gem 'naturalsorter', '2.0.5'   # natural sort
gem 'amoeba', "~> 2.0.0"

# rest API for NTT call
gem "nokogiri"
gem "rest-client", "~> 1.6.7"

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  #  gem 'deep_cloneable', '~> 1.5.2'         #############################      SQLLite issue with Heroku
end

# TODO: remove - just to test heroku
group :production do
  gem 'better_errors'
  gem 'binding_of_caller'
  #  gem 'deep_cloneable', '~> 1.5.2'         #############################      SQLLite issue with Heroku
end

group :assets do
  gem 'coffee-rails'
end

# gem 'client_side_validations'

# end added by Olivier

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

#