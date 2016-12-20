class Location < ApplicationRecord
  validates :city, presence: true

  SOCRATA_APP_TOKEN = Rails.application.secrets.socrata_app_token

  def city_id
    json = HTTParty.get("http://api.opendatanetwork.com/entity/v1?entity_name=#{URI.encode(self.city)}&app_token=#{SOCRATA_APP_TOKEN}")
    logger.debug { "city_id json: #{json}"}
    if json["entities"] && json["entities"].length > 0
      name_match = json["entities"].select { |record| record["name"] == self.city }
      if name_match.length > 0
        name_match[0]["id"]
      else
        nil
      end
    else
      nil
    end
  end

  def city_data_url
    "https://api.opendatanetwork.com/data/v1/values?app_token=#{SOCRATA_APP_TOKEN}&variable=crime.fbi_ucr.rate&entity_id=#{city_id}&crime_type=All%20Crimes"
  end

  def city_data
    HTTParty.get(city_data_url)
  end

  def all_crime
    json = city_data
    if json['error']
      json['error']['message']
    elsif json['data'].length > 0
      rows = json['data']
      rows.delete_at(0) # remove header row to enable sort
      most_recent = rows.max_by do |row|
        row[0]
      end
      formatted_rate = most_recent[1].round
      year = most_recent[0]
      "#{formatted_rate} <small>per 100,000 people (in #{year})</small>".html_safe
    end
  end

  def self.to_csv
    attributes = %w{city}
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |city|
        csv << city.attributes.values_at(*attributes)
      end
    end
  end

end
