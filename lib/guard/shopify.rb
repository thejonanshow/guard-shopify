require 'guard'
require 'guard/guard'
require 'shopify_api'
require 'ptools'

module Guard
  class Shopify < Guard
    def start
      set_config unless File.exists?("#{ENV['HOME']}/.guard_shopify")
      get_credentials_from_config
      authenticate_with_shopify
      get_main_theme_id
    end

    def get_credentials_from_config
      credentials = File.read("#{ENV['HOME']}/.guard_shopify").split("\n")

      @api_key = credentials[0]
      @password = credentials[1]
      @url = credentials[2]
    end

    def authenticate_with_shopify
      ShopifyAPI::Base.site = "https://#{@api_key}:#{@password}@#{@url}/admin"
    end

    def get_main_theme_id
      themes = ShopifyAPI::Theme.find(:all)

      main_theme = themes.select {|t| t.role == 'main'}.first

      @theme_id = main_theme.id
    end

    def run_on_change(paths)
      paths.each do |p|
        Notifier.notify("#{p} was changed.")
        puts "#{p} was changed."

        begin
          remote_asset = ShopifyAPI::Asset.find(p, :params => {:theme_id => @theme_id})
        rescue Exception => e
          puts "Error retrieving remote asset matching #{p}; nothing uploaded."
          puts e.message
        end
        
        if File.binary?(p) && remote_asset
          upload_binary_asset(p, remote_asset)
        elsif remote_asset
          upload_text_asset(p, remote_asset)
        end
      end
    end

    def upload_binary_asset(path, remote_asset)
      remote_asset.attach(File.read(path))
      remote_asset.save
      puts "#{path} uploaded to #{@url}"
    end

    def upload_text_asset(path, remote_asset)
      local_text = File.read(path)      
      remote_asset.value = local_text
      remote_asset.save
      puts "#{path} uploaded to #{@url}"
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
