class Location < ApplicationRecord
  API_KEY = Rails.application.secrets.google_maps_api_key

  def maps_query_url
    address = URI.encode(self.address)
    "https://maps.googleapis.com/maps/api/geocode/json?address=#{address}&key=#{API_KEY}"
  end

  def maps_query
    HTTParty.get(maps_query_url)
  end

  def lat_long
    json = maps_query
    if json["status"] = "OK"
      [json["results"][0]["geometry"]["location"]["lat"], json["results"][0]["geometry"]["location"]["lng"]]
    else
      "Query failed"
    end
  end

end
