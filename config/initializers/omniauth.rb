Rails.application.config.middleware.use OmniAuth::Builder do  
  provider :google_oauth2,
    ENV['GOOGLE_CLIENT_ID'],
    ENV['GOOGLE_SECRET'],
    scope: ["plus.login", "plus.me", "userinfo.email", "userinfo.profile", "https://mail.google.com/",
      "gmail.compose", "gmail.modify", "gmail.readonly"],
    access_type: 'offline'
end