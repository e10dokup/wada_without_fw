#!/usr/bin/env ruby
# coding:utf-8
require 'active_record'
require 'yaml'
require 'sinatra'
require 'rack'
require 'json'
Dir[File.expand_path('../models', __FILE__) << '/*.rb'].each do |file|
  require file
end
require './passby_query.rb'

config = YAML.load_file('config/database.yml')
ActiveRecord::Base.establish_connection(config['development'])
Time.zone_default =  Time.find_zone! 'Tokyo' # config.time_zone
ActiveRecord::Base.default_timezone = :local # config.active_record.default_timezone

# View

get '/' do
  erb :main
end

get '/user' do
  erb :user_reg
end

get '/passby' do
  erb :passby_reg
end

get '/api/passby/all' do
  status 200
  data = get_matching(Passing.all, "", "")
  data.to_json
end

get '/api/passby' do
  user = params[:user]
  date_str = params[:date]
  times = params[:times].to_i
  passed_with = params[:passed_with]
  status 200

  passings = Passing.all

  unless date_str.nil?
    date = Date.strptime(date_str, "%Y-%m-%d")
    passings = Passing.where(passing_at: date.beginning_of_day..date.end_of_day)
  end

  unless times.nil?
    # passings.each do |passing|
    #   subject_address = passing.subject_address
    #
    # end
    ary = []
    passings.each do |passing|
      subject_address = passing.subject_address
      ary.push subject_address
    end
    times_hash = ary.inject(Hash.new(0)){|hash, a| hash[a] += 1; hash}.select {|k,v| v >= times}
    times_matched = []
    times_hash.each do |address, count|
      counted = passings.select{|n| n.subject_address == address}
      counted.each do |passing|
        times_matched.push passing
      end
    end
    passings = times_matched
  end


  p passings.count

  data = get_matching(passings, user, passed_with)
  data.to_json
end

get '/api/user/all' do
  status 200
  User.all.to_json
end

# t.datetime :passing_at, null: false
# t.string :object_address, null: false
# t.string :subject_address, null: false
# t.string :app_id, null: false
post '/api/passby/create', provides: :json do
  request_param = JSON.parse request.body.read
  passing = Passing.new
  passing.passing_at = DateTime.strptime(request_param['passing_at'], "%Y/%m/%d %H:%M")
  passing.object_address = request_param['object_address']
  passing.subject_address = request_param['subject_address']
  # passing.app_id = request_param['app_id']
  passing.app_id = 'without_framework'
  result = passing.save

  if result
    status 201
    passing.to_json
  else
    status 400
    {error: '不正な値があります'}.to_json
  end
end

post '/api/passby/create_multi', provides: :json do
  request_params = JSON.parse request.body.read
  success = 0
  failure = 0
  request_params.each do |request_param|
    passing = Passing.new
    passing.passing_at = DateTime.strptime(request_param['passing_at'], "%Y/%m/%d %H:%M")
    passing.object_address = request_param['object_address']
    passing.subject_address = request_param['subject_address']
    # passing.app_id = request_param['app_id']
    passing.app_id = 'without_framework'
    result = passing.save

    if result then
      success += 1
    else
      failure += 1
    end
  end

  data = {succceeded: success, failed: failure}

  status 201
  data.to_json
end

post '/api/user/create', provides: :json do
  request_param = JSON.parse request.body.read
  user = User.new
  user.name = request_param['name']
  user.ble_uid = request_param['ble_uid']
  user.wifi_uid = request_param['wifi_uid']
  result = user.save

  if result then
    status 201
    user.to_json
  else
    status 400
    {error: '不正な値があります'}.to_json
  end
end



