# frozen_string_literal: true
source 'https://gems.ruby-china.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'pg'
gem 'rails', '~> 5.0.1'
gem 'redis', '3.3.2'
gem 'redis-objects', '~> 1.2.1'
gem 'unicorn', '~> 5.2.0'

gem 'enum_help'
gem 'figaro'
gem 'paper_trail'
gem 'paranoia'
gem 'scatter_swap'

gem 'grape', '~> 0.19.1'
gem 'grape-entity'
gem 'grape-swagger'

gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
# gem 'turbolinks', '~> 5'
# gem 'jbuilder', '~> 2.5'

group :development, :test do
  gem 'byebug', platform: :mri
end

group :development do
  gem 'annotate'
  gem 'better_errors'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'web-console'

  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'rubocop'
  gem 'rubocop-rspec'
end

group :test do
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'simplecov', require: false
end

group :deploy do
  gem 'capistrano', '~> 3.7.1'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  gem 'capistrano3-unicorn'
end
