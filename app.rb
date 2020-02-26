require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

# enter your Dark Sky API key here
ForecastIO.api_key = "65f73d6491ab81faa4973089255625d7"
# News API = 
url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=82b67568e8644a85bd77b4656a2d2818"

get "/" do
    
    # show a view that asks for the location
    
    view "ask"
end

get "/news" do

    # do everything else

    results = Geocoder.search(params["location"])
    lat_lng = results.first.coordinates
    lat = lat_lng[0]
    lng = lat_lng[1]

    @forecast = ForecastIO.forecast("#{lat}","#{lng}").to_hash
    @current_temp = @forecast["currently"]["temperature"] 
    @current_weather = @forecast["currently"]["summary"]
    @news = HTTParty.get(url).parsed_response.to_hash

    view "news"
end
