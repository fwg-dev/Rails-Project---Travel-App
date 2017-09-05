class Visit < ApplicationRecord
  belongs_to :user
  belongs_to :city
  validates :city_rating, presence: true
  validate :not_a_repeat

  def not_a_repeat
    if Visit.where(user_id: user_id, city_id: city_id).count > 1
      errors.add(:city_id, "You have already entered this visit")
    end
  end

  def set_city(city_attributes, visit, user)
    if !city_attributes[:name].empty?
      city = City.find_or_create_by(name: city_attributes[:name])
      city_attributes[:city_id] = city.id
      if !city_attributes[:country].empty?
        country = Country.find_or_create_by(name: city_attributes[:country])
        city_attributes[:country_id] = country.id
      else
        country = Country.find_by(id: city_attributes[:country_id])
      end
        country.cities << city if !city.nil? && !country.nil?
        country.save
    else
      city = City.find_by(id: city_attributes[:city_id])
    end
    if !city.nil? && !city.country.nil? && Visit.find_by(city_id: city.id, user_id: user.id ).nil?
      city.visits << visit
      city.save
    end
  end
end
