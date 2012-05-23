class ReportedListing < ActiveRecord::Base
  has_many :listings

  after_create :create_alert


  def description
    ret = case self.report_type
    when "its a scam"
      "It's a scam"
    when "not existing"
      "Place no longer exist"
    when "sexually explicit"
      "Sexually explicit content"
    when "link not working"
      "Some links in this page are not working"
    when "offensive"
      "Offensive language used"
    when "others"
      "#{report.content}"
    end
    ret
  end


  private
    def create_alert
      Alert.from_reported_listing(self, "report")
    end
end
