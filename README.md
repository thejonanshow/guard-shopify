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

    $ guard init rspec

When first run the gem will prompt you to enter your API key, password and store url. Follow [these instructions](http://http://wiki.shopify.com/Shopify_Textmate_Bundle) to get this information (you only need to do it once).

Hello Hungry Academy
====================

I wrote this project for two reasons: I needed a code sample for my hungry academy application and I wanted to make my own client work significantly less painful.

The best solution that existed before this gem was a Textmate bundle that allows you to upload modifications to Shopify with a keystroke. It sounds like a pretty good solution but Textmate and I broke up a long time ago and even having to save, upload, tab and refresh was a bit laborious for me. 

It occurred to me that a guard could watch my filesystem for changes and upload modifications immediately on saving, allowing me to use vim instead of Textmate.

This gem is not as full featured as I would like it to be, nor is it well tested, but it is my first independent open source contribution that may actually get used, and I'm quite pleased with this first release.

The immediate roadmap for guard-shopify includes test coverage, the ability to upload new files, delete existing files and optionally prompt before uploading changes to Shopify. 

I'm only counting the hungry academy section of this file towards the 200 word limit you specified; if that's unacceptable please let me know and I will remove the installation instructions. 
