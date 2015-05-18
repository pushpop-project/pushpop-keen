## pushpop-keen

Keen IO plugin for [Pushpop](https://github.com/pushpop-project/pushpop).

### Installation

Add `pushpop-keen` to your Gemfile:

``` ruby
gem 'pushpop-keen'
```

or install it as a gem:

``` shell
$ gem install pushpop-keen
```

### Usage

#### Querying 

The `keen` plugin gives you a DSL to specify Keen query parameters. Those query parameters are used to query data using the [keen-gem](https://github.com/keenlabs/keen-gem).

Here's an example that shows many of the options you can specify:

``` ruby
job 'average response time for successful requests last month' do

  keen do
    event_collection  'checks'
    analysis_type     'average'
    target_property   'request.duration'
    group_by          'check.name'
    interval          'daily'
    timeframe         'last_month',
    filters           [{ property_name: "response.successful",
                         operator: "eq",
                         property_value: true }]
  end

end
```

A `steps` method is also supported for [funnels](https://keen.io/docs/data-analysis/funnels/),
as well as `analyses` for doing a [multi-analysis](https://keen.io/docs/data-analysis/multi-analysis/).

#### Tracking

You can also very simply record events to Keen:

``` ruby
job 'send pageview'
  
  keen do
    record 'Pageview', path: '/a/path'   
  end

end
```

The `keen` plugin requires that the following environment variables are set:
  
+ `KEEN_PROJECT_ID`
+ `KEEN_READ_KEY`


### Contributing

Code and documentation issues and pull requests are welcome.
