# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def show_price(opp)
    str = ""
    unless opp.price.nil?
      unless opp.price.blank?
        if opp.price.to_f > 0
          str = " - $#{ format_price(opp.price)}"
        end
      end
    end
    str
  end

  def format_price(price)
    n = ""
    p = price.to_s.split(".")
    n = p[0] if p[0].to_i > 0
    unless p[1].nil?
      decimal = ".#{p[1]}"
      if p[1].to_f > 0
        n = n + decimal
      end
    end
    n
  end

  def show_category_name(opp)
    html = "<span class='category_label'>"
    unless opp.category.nil?
      html += opp.category.name.to_s
    end
    html += "</span>"
    html
  end
  
end
