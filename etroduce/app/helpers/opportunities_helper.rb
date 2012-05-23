module OpportunitiesHelper

  def get_message(type='respond', sender, opp)
    message = case type
    when 'respond'
      "Hi, \n\nI'm interested. Please tell me more details about this opportunity.\n\nThanks,\n#{sender.fullname.titleize}"
    when 'refer'
      "Hi #{opp.user.firstname}, \n\nI refer my friend to this post.\n\nThanks,\n#{sender.fullname.titleize}"
    when 'respond_na'
      "Hi, \n\nI'm interested. Please tell me more details about this opportunity.\n\nThanks\n"
    end
  end
end
