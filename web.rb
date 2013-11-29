def get_feed
  CSV.parse(HTTParty.get("https://api.xively.com/v2/feeds/#{ENV['XIVELY_FEED_ID']}/datastreams/#{ENV['XIVELY_STREAM_ID']}.csv?key=#{ENV['XIVELY_API_KEY']}").body)[0][0]
end

def alert_on(seconds = 300)
  if (Time.now - (Time.parse get_feed)) < seconds
    status 200
    body "OK"
  else
    status 500
    body "FAIL"
  end
end

get '/bad' do
  alert_on(2)
end

get '/' do
  alert_on ENV['XIVELY_UPDATE_THRESHOLD'].to_i
end

get '/strict' do
  alert_on ENV['XIVELY_STRICT_UPDATE_THRESHOLD'].to_i
end
