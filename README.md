# guestbook

It's a guestbook alright.  Web 1.0, here I come!

<p align="center">
  <img src="https://github.com/nilsding/guestbook/blob/master/misc/img/index.gif?raw=true" alt="Screenshot of Mozilla 1.3 displaying the guestbook" /><br>
  <img src="https://github.com/nilsding/guestbook/blob/master/misc/img/new_entry.png?raw=true" alt="Screenshot of Mozilla 1.3 displaying the guestbook's new entry page" />
</p>

## Features

- Not much yet...
- it has some BBCode support though!

## Installation

Install Crystal and PostgreSQL, then:

- install the dependencies: `shards install`
- build the application: `shards build`
- create a new Postgres database named `guestbook`

## Usage

Once `shards build` succeeded, you can run the web server via `./bin/guestbook`.

Want to run this outside of your local dev machine?  Set the environment
variable `KEMAL_ENV=production`.

Want to expose this service on a different directory other than `/`?  Just set
the `SITE_ROOT` environment variable to something, e.g:
`SITE_ROOT=/myguestbook`.

## Contributing

1. Fork it (<https://github.com/nilsding/guestbook/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Georg Gadinger](https://github.com/nilsding) - creator and maintainer
