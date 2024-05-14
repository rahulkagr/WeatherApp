# Service to get latitude and longitude of a given pin code
class GeocoderService
  attr_reader :pin_code
  RESPONSE = Struct.new(:latitude, :longitude)

  def initialize(pin_code: )
    @pin_code = pin_code
  end

  def execute
    get_lat_long
  end
  private

  def get_lat_long
    resp = Geocoder.search(pin_code)
    raise "Invalid Pin Code" if resp.blank?
    record = resp.first
    raise "Invalid response from Geocoder" if record.blank? || record.latitude.blank? || record.longitude.blank?
    RESPONSE.new(record.latitude.round(5), record.longitude.round(5))
  end
end
