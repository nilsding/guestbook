require "./bbcode"

class Entry
  PAGE_SIZE = 8

  getter id, name, email, website_name, website, location, mastodon, icon, message, created_at
  getter? email_hidden

  def initialize(@name : String,
                 @email : String,
                 @email_hidden : Bool,
                 @website_name : String,
                 @website : String,
                 @location : String,
                 @mastodon : String,
                 @icon : Int16,
                 @message : String,
                 @created_at : Time = Time.utc,
                 @id : Int64? = nil)
  end

  def self.recent(page = 1)
    offset = (page - 1) * PAGE_SIZE
    ([] of Entry).tap do |ary|
      Database.query("SELECT id, name, email, email_hidden, website_name, website, location, mastodon, icon, message, created_at FROM entries ORDER BY id DESC LIMIT #{PAGE_SIZE} OFFSET #{offset}") do |rs|
        rs.each do
          ary << from_resultset(rs)
        end
      end
    end
  end

  def self.count
    Database.scalar("SELECT COUNT(id) FROM entries;").as(Int64)
  end

  private def self.from_resultset(rs)
    new(
      id: rs.read(Int64),
      name: rs.read(String).strip,
      email: rs.read(String).strip,
      email_hidden: rs.read(Bool),
      website_name: rs.read(String).strip,
      website: rs.read(String).strip,
      location: rs.read(String).strip,
      mastodon: rs.read(String).strip,
      icon: rs.read(Int16),
      message: rs.read(String).strip,
      created_at: rs.read(Time),
    )
  end

  def save
    return unless id.nil?

    insert = "INSERT INTO entries (name, email, email_hidden, website_name, website, location, mastodon, icon, message) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)"
    Database.exec insert, name, email, email_hidden?, website_name, website, location, mastodon, icon, message
  end

  def formatted_message
    BBCode.parse(message)
  end
end
