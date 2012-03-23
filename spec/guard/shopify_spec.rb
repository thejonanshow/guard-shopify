require 'spec_helper'

describe Guard::Shopify do
  before do
    subject.stub!(:authenticate_with_shopify => true)
  end

  let(:subject) {Guard::Shopify.new}

  context "run_on_change" do
    let(:path) {'spec/fixtures/explanation.txt'}

    before do
      ShopifyAPI::Asset.stub!(:find) { true }
    end

    it "should call upload_binary_asset for binary files" do
      path = 'spec/fixtures/purikura_avatar.jpg'

      subject.should_receive :upload_binary_asset
      subject.run_on_change([path])
    end

    it "should call upload_text_asset for text files" do
      subject.should_receive :upload_text_asset
      subject.run_on_change([path])
    end

    it "should notify the user when a file is changed" do
      ShopifyAPI::Asset.stub!(:find) { false }
      Guard::Notifier.should_receive(:notify).with /#{path}/
      subject.run_on_change([path])
    end
  end

  context "start" do
    it "should prompt the user for their credentials if the config file doesn't exist" do
      File.stub!(:exists?) { false }
      subject.should_receive(:set_config).and_return true
      subject.start
    end
  end

  context "set_config" do
    it "should write the credentials to a config file" do
      File.should_receive(:open).with "#{ENV['HOME']}/.guard_shopify", "w"
      subject.stub!(:gets).and_return('Foo')
      subject.send(:set_config)
    end

    it "should accurately to the user the location of the config file" do
      subject.should_receive(:puts).with "Credentials saved to #{ENV['HOME']}/.guard_shopify"
    end
  end
end
