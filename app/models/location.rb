class Location < ApplicationRecord
  validates :city_name, presence: true
  validates :city_id, presence: { message: "not found in our database. Please enter a city and state in this format: Dallas, TX" }

  SOCRATA_APP_TOKEN = Rails.application.secrets.socrata_app_token

  def get_city_id
    json = HTTParty.get("http://api.opendatanetwork.com/entity/v1?entity_name=#{URI.encode(self.city_name)}&app_token=#{SOCRATA_APP_TOKEN}")
    logger.debug { "city_id json: #{json}"}
    if json["entities"] && json["entities"].length > 0
      name_match = json["entities"].select { |record| record["name"] == self.city_name }
      if name_match.length > 0
        self.city_id = name_match[0]["id"]
      else
        logger.warn { "City ID response did not match city name: #{json["entities"]}"}
        nil
      end
    else
      logger.warn { "City ID response for #{self.city_name} contained no entities: #{json}" }
      nil
    end
  end

  def city_data_url
    "https://api.opendatanetwork.com/data/v1/values?app_token=#{SOCRATA_APP_TOKEN}&variable=crime.fbi_ucr.rate&entity_id=#{self.city_id}&crime_type=All%20Crimes"
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
      "#{formatted_rate} <small>per 100,000 people (in #{year})</small>"
    end
  end

  def self.to_csv
    attributes = %w{city_name crime_rate}
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |city|
        csv << city.attributes.values_at(*attributes)
      end
    end
  end

  def calculate_crime_rate
    self.city_id = get_city_id
    self.crime_rate = all_crime
  end
  before_validation :calculate_crime_rate

end
