require "kemal"

macro render_layouted(path)
  render "src/views/#{{{ path }}}", "src/views/layout.ecr"
end

SITE_ROOT = ENV.fetch("SITE_ROOT", "")

Kemal.config.powered_by_header = false
error 404 do
  render "src/views/errors/404.ecr"
end
if ENV.fetch("KEMAL_ENV", "development") == "production"
  error 500 do
    render "src/views/errors/500.ecr"
  end
end

get "/" do |env|
  page = (env.params.query["page"]? || "1").strip.to_i
  page_count = (Entry.count // Entry::PAGE_SIZE) + 1
  page = 1 unless (1..(page_count)).covers?(page)

  entries = Entry.recent(page: page)
  render_layouted "page.ecr"
end

get "/new" do
  render_layouted "new.ecr"
end

post "/new" do |env|
  name = env.params.body["name"].as(String).strip
  email = env.params.body["email"].as(String).strip
  email_hidden = env.params.body.has_key?("email_hidden")
  website_name = env.params.body["website_name"].as(String).strip
  website = env.params.body["website"].as(String).strip
  location = env.params.body["location"].as(String).strip
  mastodon = env.params.body["mastodon"].as(String).strip
  icon = env.params.body["icon"].as(String).strip.to_i16
  message = env.params.body["message"].as(String).strip

  errors = [] of String

  website = "" if %w[http:// https://].includes?(website)

  errors << "Name must be set" if name.empty?
  errors << "Email must be set" if email.empty?
  errors << "Message must be set" if message.empty?

  errors << "Name must be less than 80 characters" if name.size > 80
  errors << "Email must be less than 180 characters" if email.size > 180
  errors << "Website name must be less than 120 characters" if website_name.size > 120
  errors << "Website URL must be less than 255 characters" if website.size > 255
  errors << "Location must be less than 50 characters" if location.size > 50
  errors << "Mastodon must be less than 80 characters" if mastodon.size > 80

  errors << "Email is invalid" unless email.includes?("@")
  errors << "Website URL must start with http:// or https://" unless website.empty? || website =~ %r{^https?://}
  errors << "Mastodon must be in the format of <tt>@username@example.com</tt>" unless mastodon.empty? || mastodon =~ /^@[a-z0-9_]+(?:[a-z0-9_\.-]+[a-z0-9_]+)?@(?:[^@]*)\.(?:.[^@]+)$/
  errors << "Icon must be between 1 and 15" unless (1..15).covers?(icon)

  unless errors.empty?
    next render_layouted "error.ecr"
  end

  entry = Entry.new(
    name: name,
    email: email,
    email_hidden: email_hidden,
    website_name: website_name,
    website: website,
    location: location,
    mastodon: mastodon,
    icon: icon,
    message: message,
  )
  entry.save
  env.redirect("#{SITE_ROOT}/")
end

Kemal.run
