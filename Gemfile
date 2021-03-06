source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

gem 'rails', '~> 6.1.3'

# Database
gem 'sqlite3', '~> 1.4', :platform => [:ruby, :mswin, :mingw]
gem "jdbc-sqlite3", :platform => :jruby

# Server
gem 'puma', '~> 5.0'

# Client
gem 'bootsnap', '>= 1.4.4', require: false
gem 'sass-rails', '>= 6'
gem 'turbolinks', '~> 5'
gem 'webpacker', '~> 5.0'

# Authentication
gem 'devise'

#CORS
gem 'rack-cors'

#Rendering
gem 'jbuilder', '~> 2.10.1'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pry-byebug'
  gem 'fabrication'
  gem 'faker'
end

group :development do
  gem 'web-console', '>= 4.1.0'
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'rubocop', require: false
  gem 'listen', '~> 3.3'
  gem 'spring'
end

group :test do
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  gem 'webdrivers'
  gem 'simplecov', require: false
  gem 'coveralls', require: false
  gem 'coveralls_reborn', '~> 0.21.0', require: false
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
