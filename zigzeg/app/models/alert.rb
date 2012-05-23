class Alert < ActiveRecord::Base
  belongs_to :sender, :polymorphic => true
  belongs_to :reportable, :polymorphic => true
  cattr_reader :per_page
  self.per_page = 20

  scope :pending, where("status='pending'")

  class << self
    def get_alerts(page, type=nil)
      conditions = nil

      unless type.nil?
        conditions = "alert_type = '#{type}'"
      end

      paginate :page => page,
               :conditions => conditions,
               :order => "created_at DESC",
               :per_page => 10
    end

    def from_reported_listing(report, rtype)
      a = Alert.new
      a.alert_type = rtype
      a.reportable = report
      a.title = report.report_type
      a.sender_id = report.user_id unless report.user_id.nil?
      a.sender_type = "User" unless report.user_id.nil?
      a.save!
    end

  end

  def description
    unless self.reportable.nil?
      return self.reportable.description if self.reportable.class == ReportedListing
    else
      super
    end
  end
end
