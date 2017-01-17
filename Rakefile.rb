require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'
# require 'seed-fu'

# namespace :db do
#   task :seed_fu do
#     SeedFu.seed
#   end
#
#   task :load_config do
#     require './app.rb'
#   end
# end
#
# namespace :test do
#   task :print do
#     p "test"
#   end
# end
#
# Rake::Task['db:seed_fu'].enhance(['db:load_config'])