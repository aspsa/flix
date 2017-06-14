module ReviewsHelper
  def format_average_stars(movie)
    if movie.unrated?
      content_tag(:strong, "No reviews")
    else
      #pluralize(number_with_precision(movie.average_stars, precision: 1), 'star') + "\n" + ("*" * movie.average_stars.round))
      rating = pluralize(number_with_precision(movie.average_stars, precision: 1), 'star')
      rating += "*" * movie.average_stars.round
    end
  end
end