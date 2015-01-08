# RtApi

A Ruby wrapper for the [RT ticketing system's API interface](http://requesttracker.wikia.com/wiki/REST).
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rt_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rt_api

## Usage

The primary interface is through the RTApi::Session object. When initialized,
this will set it's @connection to an RTApi::Connection instance. This
This connection will be tested for validity on creation and throw an
RTApi::ConnectionError if it cannot receive a response from the RT instance
specified.

### Specifying connection settings

There are two methods for passing connection settings on creation of a Session
object:

1.  Setting Environment Variables
    The following environment variables are required:
      * rt_api_user
      * rt_api_pass
      * rt_api_url
    An optional rt_api_path variable can be set, if you're not using the API's
    default '/REST/1.0/' path.

2.  Passing a :connection hash
    As an example:

      ```ruby
      RTApi::Session.new({ connection: { username: 'test_user', password: 'test_pass', base_url: 'http://test.com'})
      ```
    This method of seesion creation also supports an options :path element.

