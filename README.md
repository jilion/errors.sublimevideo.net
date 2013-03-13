# SublimeVideo Player Errors Reporter (Rack + Puma)

## Installation

``` bash
more .gitconfig > .git/config
bundle install
```

## Development

Running:

``` bash
bundle exec rackup
```

## Deployment

``` bash
git push production
```

## CORS data requests

CORS Ajax requests are always sent to the same url via POST HTTP(S):

`POST //errors.sublimevideo.net/report`

The params (json) sent *must at least* include a `message` key or both `file` and `lineno` keys.
The params (json) can contain a `stack` key that will be used by Airbrake for better displaying.

The server replies [200, "{ message: 'OK' }"] if the exception is valid.
