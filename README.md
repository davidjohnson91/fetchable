# Fetchable

Fetchable is an interface between your application and your APIs that simulates some of the nicities of ActiveRecord.

## Installation

Add this line to your application's Gemfile:

    gem 'fetchable'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fetchable

## Usage

Fetchable is meant to simulate some of the most common interfaces for ActiveRecord when using an API.

There are currently two public interfaces for retrieving data, ```.where```/```.all``` and ```.find```.

### Fetchable.where
Given an API response at ```/deals.json``` that looks like this:

```
[
  {
    id: 1,
    name: "Amazing deal at Amazon",
    ...
  },
  {
    id: 2,
    name: "Brad's exclusive deal of the day",
    ...
  }
]
```

A call to ```Fetchable.where``` will send a request to your API, parse the response, and return an array of instances based on the initialize method of your class.

### Fetchable.find
Given an API response at ```/deals/1.json``` that looks like this:

```
{
  id: 1,
  name: "Amazing deal at Amazon",
  ...
}
```
A call to ```Fetchable.find(1)``` will return a new instance of the class based on data received from the API.

## Extensibility
Fetchable is designed to be configurable at every level and provides some options in order to protect your API calls and correctly parse non-standard responses.

### resource_name
What is the RESTful resource name on your api? By default this is the class name pluralized (ex: Deal => deals).

### collection_url & singular_url
These methods define how to form the endpoint that .where and .find will use when asking for resources from the API.

### parse_collection & parse_singular
These methods define how to parse the response from the API. Some reasons to override this may be to account for non-standard keys or unneeded values returned from an API.

### allowed_connection_options
This array should contain the keys of query values that you want to expose to your API. Used in conjuction with whitelist_arguments to remove unsafe or unintended arguments from your API request.
