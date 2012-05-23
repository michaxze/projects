module ListingsHelper

  def format_post_link(post)
    name = clean(post.name)
    letter = Constant::LISTING_TYPES["#{post.listing_type}"]
    html = "#{root_url}#{name}-#{letter}#{post.id}"
  end

  def clean(name)
    name.gsub!(/(['",;&^$%@!+:*#.])/, '')
    name.gsub!("  ", " ")
    name.downcase.gsub(" ", "-")
  end

end
