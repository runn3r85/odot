require 'spec_helper'

describe User do
    let(:valid_attributes) {
      {
        first_name: "Brandon",
        last_name: "Barrette",
        email: "brandon@mrbarrette.com"
      }
    }

  context "validations" do
    let(:user){ User.new(valid_attributes) }

    before do
      User.create(valid_attributes)
    end

    it "requires an email" do
      expect(user).to validate_presence_of(:email)
    end

    it "requires a unique e-mail" do
      expect(user).to validate_uniqueness_of(:email)
    end

    it "requires a unique e-mail case insensitive" do
      user.email = "BRANDON@MRBARRETTE.COM"
      expect(user).to validate_uniqueness_of(:email)
    end

  end

  describe "#downcase_email" do
    it "makes the email attribute lower case" do
      user = User.new(valid_attributes.merge(email: "BRANDON@MRBARRETTE.COM"))
      user.downcase_email
      expect(user.email).to eq("brandon@mrbarrette.com")
    end

    it "downcaes an e-mail before saving" do
      user = User.new(valid_attributes)
      user.email = "STUDENT@MRBARRETTE.COM"
      expect(user.save).to be_true
      expect(user.email).to eq("student@mrbarrette.com")
    end
  end


end
