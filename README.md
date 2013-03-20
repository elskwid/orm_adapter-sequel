# ORM Adapter - Sequel Adapter

## Description

Adds the Sequel ORM adapter to the ORM Adapter project.

## Requirements

  * [ActiveModel >= 3.0.0](https://github.com/rails/rails/tree/master/activemodel)
  * [orm_adapter >= 0.4.0](https://github.com/ianwhite/orm_adapter)
  * [Sequel >= 3.18.0](https://github.com/jeremyevans/sequel)

This gem has been tested against Ruby 1.9.3.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "orm_adapter-sequel"
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install orm_adapter-sequel
```

## ORM Adapter

> "Provides a single point of entry for popular ruby ORMs. Its target audience is gem authors who want to support more than one ORM."

For more information see the [orm_adapter project](http://github.com/ianwhite/orm_adapter).

## Development / Testing

This project is tested against `orm_adapter` to make sure it works as advertised. A Rake task is available to get the latest orm_adapter specs. It will checkout the project to a temporary directory and copy over the specs needed to run.

```
$ rake update_orm_specs
```

To run the tests:

```
$ rake spec
```

## Contributing

1. [Fork it](https://github.com/elskwid/orm_adapter-sequel/fork_select)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. [Create a Pull Request](https://github.com/elskwid/orm_adapter-sequel/pull/new)

## Contributors

* Rachot Moragraan [(mooman)](https://github.com/mooman)
* Rodrigo Rosenfeld Rosas [(rosenfeld)](https://github.com/rosenfeld)

## License

* Freely distributable and licensed under the MIT license.
* Copyright (c) 2011-2013 Don Morrison ([elskwid](https://github.com/elskwid)). See LICENSE for details.
