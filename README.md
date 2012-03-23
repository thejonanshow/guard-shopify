Guard::Shopify
==============

The Shopify guard uploads template modifications directly to Shopify, allowing you to forego the existing Textmate bundle and use any editor you like to modify Shopify templates.

Installation
------------

Please be sure to have [Guard](https://github.com/guard/guard) installed before you continue.

Install the gem:

    $ gem install guard-shopify

Add guard-shopify to your Gemfile (inside the development group):

``` ruby
group :development do
  gem 'guard-shopify'
end
```

Add the guard definition to your Guardfile:

    $ guard init guard

When first run the gem will prompt you to enter your API key, password and store url. Follow [these instructions](http://wiki.shopify.com/Shopify_Textmate_Bundle) to get this information (you only need to do it once).
