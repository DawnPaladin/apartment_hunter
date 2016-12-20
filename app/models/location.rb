class Location < ApplicationRecord
  validates :city, presence: true

  SOCRATA_APP_TOKEN = Rails.application.secrets.socrata_app_token

  def city_id
    json = HTTParty.get("http://api.opendatanetwork.com/entity/v1?entity_name=#{URI.encode(self.city)}&app_token=#{SOCRATA_APP_TOKEN}")
    if json["entities"].length > 0
      json["entities"][0]["id"]
    else
      nil
    end
  end

  def city_data_url
    "https://api.opendatanetwork.com/data/v1/values?app_token=#{SOCRATA_APP_TOKEN}&format=google&variable=crime.fbi_ucr.rate&entity_id=#{city_id}&year=2014"
  end

  def city_data
    HTTParty.get(city_data_url)
  end

  def all_crime
    json = city_data
    if json['error']
      json['error']['message']
    elsif json['data']['rows'].length > 0
      rows = json['data']['rows']
      all_crimes_row = rows.select { |row| row['c'][0]['v'] == "All Crimes"}
      all_crimes_row[0]['c'][1]['f']
    end
  end

end
