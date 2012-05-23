Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['187000994736848'], ENV['00f42a365e237a95c07869e081187df4'],
           :scope => 'email,offline_access,read_stream', :display => 'popup'
end