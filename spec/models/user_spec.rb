require 'spec_helper'

describe User do
    let(:valid_attributes) {
      {
        first_name: "Brandon",
        last_name: "Barrette",
        email: "brandon@mrbarrette.com",
        password: "math1234",
        password_confirmation: "math1234"
      }
    }

  context "relationships" do
    it { should have_many(:todo_lists) }
  end

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

    it "requires the e-mail address to look like an e-mail" do
      user.email = "brandon"
      expect(user).to_not be_valid
    end

  end

  describe "#downcase_email" do
    it "makes the email attribute lower case" do
      user = User.new(valid_attributes.merge(email: "BRANDON@MRBARRETTE.COM"))
      user.downcase_email
      expect(user.email).to eq("brandon@mrbarrette.com")
    end

    it "downcase an e-mail before saving" do
      user = User.new(valid_attributes)
      user.email = "STUDENT@MRBARRETTE.COM"
      expect(user.save).to be_true
      expect(user.email).to eq("student@mrbarrette.com")
    end
  end

  describe "#generate_password_reset_token!" do
    let(:user) { create(:user) }
    it "changes the password_reset_token attribute" do
      expect{ user.generate_password_reset_token! }.to change{user.password_reset_token}
    end

    it "calls SecureRandom.urlsafe_base64 to generate the password_reset_token" do
      expect(SecureRandom).to receive(:urlsafe_base64)
      user.generate_password_reset_token!
    end
  end



end