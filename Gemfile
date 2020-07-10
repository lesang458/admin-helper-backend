source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

# Brings convention over configuration to your JSON generation.
gem 'active_model_serializers'
# Use Active Model has_secure_password
gem 'bcrypt', '~> 3.1.7'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false
# Create fake data
gem 'ffaker'
# Use to create tokens with high security and security, avoiding theft between different systems
gem 'jwt'
# Use pagination
gem 'kaminari-activerecord'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Puma processes requests using a C-optimized Ragel extension  that provides fast, accurate HTTP 1.1 protocol parsing in a portable way. Puma then serves the request using a thread pool
gem 'puma', '~> 4.1'
# Rack::Cors provides support for Cross-Origin Resource Sharing (CORS) for Rack compatible web applications.
gem 'rack-cors'
# Create full-stack web framework
gem 'rails', '~> 6.0.2', '>= 6.0.2.2'
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development do
  # The Listen gem listens to file modifications and notifies you about the changes.
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  # This gem makes Spring watch the filesystem for changes using Listen rather than by polling the filesystem.
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :development, :test do
  # Create object for Uni-test
  gem 'factory_bot_rails'
  # Adds step-by-step debugging and stack navigation capabilities to pry using byebug.
  gem 'pry-byebug'
  # Brings the RSpec testing framework to Ruby on Rails as a drop-in alternative to its default testing framework
  gem 'rspec-rails', '~> 4.0.0'
  # RuboCop is a Ruby static code analyzer and code formatter
  gem 'rubocop'
  # Performance optimization analysis for your projects
  gem 'rubocop-performance', require: false
  # Helps you write more understandable, maintainable Rails-specific tests under Minitest.
  gem 'shoulda', '~> 3.5'
  # Provides RSpec- and Minitest-compatible one-liners to test common Rails functionality that, if written by hand, would be much longer, more complex, and error-prone.
  gem 'shoulda-matchers', '~> 2.0'
end
