require 'sinatra'
require 'pg'
require 'time'
require 'pry'

def db_connection
  begin
    connection = PG.connect(dbname: "vegetables")
    yield(connection)
  ensure
    connection.close
  end
end

get "/" do

  ripe = false

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

  def is_it_ripe?(vegetable)
    today = Time.now.yday()

    start_day = db_connection do |conn|
      conn.exec("SELECT start_day FROM boston WHERE vegetable = ($1)", [vegetable]).to_a[0]["start_day"].to_i
    end

    end_day = db_connection do |conn|
      conn.exec("SELECT end_day FROM boston WHERE vegetable = ($1)", [vegetable]).to_a[0]["end_day"].to_i
    end

    if winter_veg?(vegetable)
      today += 365
    end

    if (start_day..end_day).include?(today)
      ripe = true
    else
      ripe = false
    end
    return ripe
  end

erb :index, locals: { ripe: ripe }
end
