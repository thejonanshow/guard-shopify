require 'guard'
require 'yaml'
require 'guard/guard'
require 'shopify_api'
require 'ptools'

module Guard
  class Shopify < Guard
    def start
      set_config unless File.exists?(config_file_path)
      get_credentials_from_config
      authenticate_with_shopify
      get_main_theme_id
    end

    def config_file_path
      "#{ENV['HOME']}/.guard_shopify"
    end

    def get_credentials_from_config
      config = YAML.load_file(config_file_path)
      # Check if config file is old format or new YAML-based one
      unless config['secret']
        config = upgrade_config_file
      end
      @url = config['url']
      @api_key = config['api_key']
      @password = config['password']
    end

    # Old line-based config file format
    def upgrade_config_file
      puts "Old config file found, upgrading..."
      
      credentials = File.read(config_file_path).split("\n")
      config = {}
      config['api_key'] = credentials[0]
      config['password'] = credentials[1]
      config['url'] = credentials[2]

      config['secret'] = prompt "Please enter your API Shared Secret"

      write_config config

      puts 'Upgraded old config file to new format'

      config
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

    def prompt msg=nil
      print "#{msg || 'Please type'}: "
      gets.chomp
    end

    def write_config config
      File.open(config_file_path, 'w') {|f| f.write(YAML.dump(config)) }
    end

    def set_config
      config = {}
      puts "This guard needs your API credentials to access your Shopify store."
      
      config['api_key'] = prompt 'Please enter your API key'
      
      config['secret'] = prompt 'Please enter your API Shared Secret'
      
      config['url'] = prompt "Please enter your store's url (e.g. awesomesauce.myshopify.com)"
      
      unless config['url'].include?('myshopify.com')
        config['url'] = "#{config['url']}.myshopify.com"
      end
      
      write_config config
      puts "Credentials saved to #{config_file_path}"
    end
  end
end
