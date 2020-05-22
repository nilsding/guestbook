require "db"
require "pg"

Database = DB.open "postgres:///guestbook"
at_exit { Database.close }

# schema migrations
Database.exec("CREATE TABLE IF NOT EXISTS schema_migrations (version BIGINT PRIMARY KEY NOT NULL);")
current_version = Database.scalar("SELECT MAX(version) FROM schema_migrations").as(Int64?) || 0i64

macro migration(version, &block)
  if current_version < {{ version }}
    puts "Migrating database to version {{ version }}"
    {{ block.body }}
    Database.exec("INSERT INTO schema_migrations (version) VALUES ($1)", {{ version }})
  end
end

migration 1 do
  Database.exec <<-SQL
    CREATE TABLE entries (
      id           BIGSERIAL PRIMARY KEY NOT NULL,

      name         TEXT     NOT NULL,
      email        TEXT     NOT NULL,
      email_hidden BOOLEAN  NOT NULL DEFAULT TRUE,
      website_name TEXT     NOT NULL DEFAULT '',
      website      TEXT     NOT NULL DEFAULT '',
      location     TEXT     NOT NULL DEFAULT '',
      mastodon     TEXT     NOT NULL DEFAULT '',
      icon         SMALLINT NOT NULL DEFAULT 1,
      message      TEXT     NOT NULL DEFAULT '',

      created_at   TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT (NOW() AT TIME ZONE 'utc')
    );
  SQL
end
