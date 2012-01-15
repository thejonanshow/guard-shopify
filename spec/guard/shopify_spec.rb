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
end
