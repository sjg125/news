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
@news = HTTParty.get(url).parsed_response.to_hash

get "/" do
  # show a view that asks for the location
    view "ask"
end

get "/news" do
  # do everything else

  # params is a hash built into Ruby
  # "location" is the name of a key, or a property within the hash. It is drawn from the ask.erb tab, where it was the name created for whatever is input into the form
    results = Geocoder.search(params["location"])
  # lat_lng is not a hash - it's an array. 
  # If we have # in curly brackets with ruby syntax means that there is string interpolation
  # results is an array, recalling the first element of the array, then getting the coordinates
    lat_lng = results.first.coordinates
    lat = lat_lng[0]
    lng = lat_lng[1]

    #need @ signs if want to display the information in the erb file and consequently the browser
    @forecast = ForecastIO.forecast("#{lat}","#{lng}").to_hash
    #@current_temp = @forecast["currently"]["temperature"] 
    #@current_weather = @forecast["currently"]["data"][0]["summary"]
    @todaysforecast = "The forecast for today is a high temperature of #{@forecast["daily"]["data"][0]["temperatureHigh"]} 
    and #{@forecast["daily"]["data"][0]["summary"]}"
    @tomorrowsforecast = "Tomorrow's forecast is a high temperature of #{@forecast["daily"]["data"][1]["temperatureHigh"]} 
    and #{@forecast["daily"]["data"][1]["summary"]}"

    # @Title = "#{@news["title"][0]}"
    # @Description = "#{@news["description"][0]}"
    # @Link= "#{@news["link"][0]}"

    view "news"
end
