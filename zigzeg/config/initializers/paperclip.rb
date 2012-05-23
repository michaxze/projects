Paperclip.interpolates :uploadable_type  do |attachment, style|
  "#{attachment.instance.uploadable_type.downcase}-#{attachment.instance.uploadable_id}"
end
