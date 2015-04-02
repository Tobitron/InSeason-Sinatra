require 'sinatra'
require 'pg'
require 'time'
require 'date'
require 'pry'
require_relative 'models/today'

enable :sessions

def db_connection
  begin
    connection = PG.connect(dbname: "vegetables")
    yield(connection)
  ensure
    connection.close
  end
end

# Create an array of all vegetables
all_veg = db_connection do |conn|
  conn.exec("SELECT vegetable FROM boston;")
end

BOS_VEGETABLES = []

all_veg.to_a.each do |vegetable|
  BOS_VEGETABLES << vegetable["vegetable"]
end

def winter_veg?(vegetable)
  winter_check = db_connection do |conn|
    conn.exec("SELECT winter_vegetable FROM boston WHERE vegetable = ($1)", [vegetable]).to_a[0]["winter_vegetable"]
  end

  if winter_check == "t"
    return true
  else
    return false
  end
end

def ripe_vegetables(vegetable_list)
  ripe_vegetables = []
  not_ripe_vegetables = []

  if session[:date] == nil
    date = Time.now.yday()
  else
    date = Date.parse(session[:date])
    date = date.yday()
  end

  vegetable_list.each do |vegetable|
    start_day = db_connection do |conn|
      conn.exec("SELECT start_day FROM boston WHERE vegetable = ($1)", [vegetable]).to_a[0]["start_day"].to_i
    end

    end_day = db_connection do |conn|
      conn.exec("SELECT end_day FROM boston WHERE vegetable = ($1)", [vegetable]).to_a[0]["end_day"].to_i
    end

    if winter_veg?(vegetable)
      date += 365
    end

    if (start_day..end_day).include?(date)
      ripe_vegetables << vegetable
    else
      not_ripe_vegetables << vegetable
    end
  end

  return ripe_vegetables, not_ripe_vegetables
end

def get_col_size(ripe)
  if ripe.length == 1
    col_size = 6
  elsif ripe.length == 3
    col_size = 4
  elsif ripe.length == 4
    col_size = 3
  elsif ripe.length == [5..6]
    col_size = 4
  elsif ripe.length == [7..12]
    col_size = 3
  else ripe.length == [12..50]
    col_size = 2
  end

  return col_size
end


get "/" do
  ripe = ripe_vegetables(BOS_VEGETABLES)[0]
  not_ripe = ripe_vegetables(BOS_VEGETABLES)[1]
  col_size = get_col_size(ripe)

  erb :index, locals: { col_size: col_size, ripe: ripe, not_ripe: not_ripe }
end

post "/" do
  session[:date] = params[:ripe_date]
  redirect '/'
end
