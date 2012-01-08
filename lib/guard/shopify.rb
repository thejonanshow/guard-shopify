require 'guard'
require 'guard/guard'
require 'shopify_api'

module Guard
  class Shopify < Guard
    def start
      set_config unless File.exists?("#{ENV['HOME']}/.guard_shopify")

      config_file = File.open("#{ENV['HOME']}/.guard_shopify", 'r')

      credentials = []
      config_file.lines.each do |line|
        credentials.push(line.chomp)
      end

      @api_key = credentials[0]
      @password = credentials[1]
      @url = credentials[2]

      config_file.close
    end

    def run_on_change(paths)
      paths.each do |p|
        Notifier.notify("#{p} changes have been uploaded.")
      end
    end

    private

    def set_config
      puts "This guard needs your API credentials to access your Shopify store."
      puts "Please enter your API key:"
      api_key = gets.chomp
      puts "Please enter your password:"
      password = gets.chomp
      puts "Please enter your store's url (e.g. awesomesauce.myshopify.com):"
      url = gets.chomp
      url = url + '.myshopify.com' unless url.include?('myshopify.com')
      
      config = [api_key, password, url].join("\n")

      File.open("#{ENV['HOME']}/.guard_shopify", 'w') {|f| f.write(config) }
      puts "Credentials saved to #{ENV['HOME']}/.guard_shopify"
    end
  end
end
