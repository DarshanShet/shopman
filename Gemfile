source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.3.3'
gem 'rails', '~> 5.0.7'
gem 'mysql2', '>= 0.3.18', '< 0.6.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'

group :development, :test do
  gem 'byebug', platform: :mri
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Reduces boot times through caching; required in config/boot.rb
#gem 'bootsnap', '>= 1.4.1', require: false

gem "font-awesome-rails"
gem 'thin', '1.7.2'
gem 'devise', '4.6.2'
gem 'jquery-ui-rails'
gem 'kaminari', '1.2.1'
gem 'momentjs-rails', '2.20.1'
gem 'thinreports-rails'
gem 'roo', '~> 2.7', '>= 2.7.1'
gem 'caxlsx', '3.0.0'
gem 'caxlsx_rails', '0.6.2'
gem 'render_async'