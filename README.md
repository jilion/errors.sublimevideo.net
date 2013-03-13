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

The params (json) sent *must at least* include a `message` key.

Allowed parameters:

``` ruby
'message' => The error message.
'stack'   => The stack traces. Must be an array of strings.
'file'    => The file from which the JS error originated.
'lineno'  => The line number from which the JS error originated.
```

The server will reply [200, "{ message: 'OK' }"] if the exception is valid.
