class Visit < ApplicationRecord
  belongs_to :user
  belongs_to :city
  has_attached_file :avatar, default_url: ':style/default.png', styles: { thumb: "100x100>" }
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
  validates :city_rating, presence: true
  validate :not_a_repeat

 def self.avg_rating_for_city(city_id)
   where('city_id = ?', city_id).average(:city_rating).to_f
 end

 def self.avg_rating
    average(:city_rating).to_f
 end

  def avatar_url
    avatar.url(:thumb)
  end

  def not_a_repeat
    if Visit.where(user_id: user_id, city_id: city_id).count > 0
      errors.add(:city_id, "You have already entered this visit")
    end
  end

  def city_attributes=(city_attributes)
    if !city_attributes[:name].empty?
      city = City.find_or_create_by(name: city_attributes[:name])
      if !city_attributes[:country].empty?
        country = Country.find_or_create_by(name: city_attributes[:country])
      else
        country = Country.find_by(id: city_attributes[:country_id])
      end
      country.cities << city if !city.nil? && !country.nil?
      country.save if !country.nil?
      self.city_id = city.id
    end
  end
end
