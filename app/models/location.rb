class Location < ApplicationRecord
  validates :city, presence: true

  API_KEY = Rails.application.secrets.google_maps_api_key
  SOCRATA_APP_TOKEN = Rails.application.secrets.socrata_app_token

  def maps_query_url
    address = URI.encode(self.address)
    "https://maps.googleapis.com/maps/api/geocode/json?address=#{address}&key=#{API_KEY}"
  end

  def maps_query
    HTTParty.get(maps_query_url)
  end

  def lat_long
    json = maps_query
    if json["status"] = "OK" && json["results"].length > 0
      [json["results"][0]["geometry"]["location"]["lat"], json["results"][0]["geometry"]["location"]["lng"]]
    end
  end

  def city_id
    json = HTTParty.get("http://api.opendatanetwork.com/entity/v1?entity_name=#{URI.encode(self.city)}&app_token=#{SOCRATA_APP_TOKEN}")
    if json["entities"].length > 0
      json["entities"][0]["id"]
    else
      nil
    end
  end

end
