source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.1'
gem 'rails-i18n', '~> 5.0.0'
gem 'mongoid', '~> 6.1.0'
gem "mongoid-enum", :github => 'monster-media/mongoid-enum'
gem 'mongoid-autoinc'

gem 'devise'
gem 'devise-i18n'
gem 'devise-bootstrap-views'
gem "pundit"

gem 'slim-rails'
gem 'simple_form'

# Use Puma as the app server

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'foreman'
# Added at 2017-08-11 10:29:14 +0300 by max:
gem "omniauth-facebook", "~> 4.0"

# Added at 2017-08-16 21:19:06 +0300 by max:
gem "carrierwave", "~> 1.1"

# Added at 2017-08-16 21:20:11 +0300 by max:
gem "carrierwave-mongoid", "~> 0.1.0"

# Added at 2017-08-16 21:20:44 +0300 by max:
gem "carrierwave-imageoptimizer", "~> 1.4"

# Added at 2017-08-16 21:21:27 +0300 by max:
gem "mini_magick", "~> 4.8"

# Added at 2017-08-16 21:22:33 +0300 by max:
gem "kaminari", "~> 1.0"


gem 'mina'
gem 'mina-puma',  require: false
gem 'mina-nginx', require: false
gem 'puma', '~> 3.10'

# Added at 2017-09-11 10:48:58 +0300 by max:
gem "bootstrap-sass", "~> 3.3"

# Added at 2017-09-11 10:51:12 +0300 by max:
gem "jquery", "~> 0.0.1"
