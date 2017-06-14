class Movie < ApplicationRecord
  validates :title, :released_on, :duration, presence: true
  validates :description, length: { minimum: 25 }
  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }
  validates :image_file_name, allow_blank: true, format: {
    with:     /\w+\.(gif|jpg|png)\z/i,
    message:  "must reference a GIF, JPG or PNG image"
  }
  RATINGS = %w(G PG PG-13 R NC-17)
  validates :rating, inclusion: { in: RATINGS }
  
  has_many :reviews, dependent: :destroy
  
  def self.released
    where("released_on <= ?", Time.now).order("released_on desc")
  end

  def self.hits
    where('total_gross >= 300000000').order(total_gross: :desc)
  end

  def self.flops
    where('total_gross < 50000000').order(total_gross: :asc)
  end

  def self.recently_added
    order('created_at desc').limit(3)
  end

  def flop?
    # Change the definition of the flop? method so that cult classics aren't included. For example, if a movie has more than 50 reviews and the average review is 4 stars or better, then the movie shouldn't be a flop regardless of the total gross.

    # Here's a hint: Because the logic for determining whether a movie is a flop is tucked inside the Movie model, you can make this change in one place. When you can do that, you know you're on the right design path!
    #total_gross.blank? || total_gross < 50000000
    total_gross.blank? || total_gross < 50000000 && !(reviews.size >= 40 && average_stars >= 4)
  end
  
  def average_stars
    reviews.average(:stars)
  end
  
  def unrated?
    reviews.size == 0
  end
  
  def recent_reviews
    reviews.order('created_at desc').limit(2)
  end
end