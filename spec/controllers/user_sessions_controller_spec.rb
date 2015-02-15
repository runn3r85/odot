require 'spec_helper'

describe UserSessionsController do

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end

    it "renders the new template" do
      get 'new'
      expect(response).to render_template('new')
    end
  end

  describe "POST 'create'" do
    context "with correct credentials" do
      let!(:user) { user = User.create(first_name: "Brandon", last_name: "Barrette", email: "brandon@mrbarrette.com", password: "math1234", password_confirmation: "math1234") }

      it "redirects to the todo list path" do
        post :create, email: "brandon@mrbarrette.com", password: "math1234"
        expect(response).to redirect_to(todo_lists_path)
      end

      it "finds the user" do
        expect(User).to receive(:find_by).with({email: "brandon@mrbarrette.com"}).and_return(user)
        post :create, email: "brandon@mrbarrette.com", password: "math1234"
      end

      it "authenticates the user" do
        User.stub(:find_by).and_return(user)
        expect(user).to receive(:authenticate)
        post :create, email: "brandon@mrbarrette.com", password: "math1234"
      end

      it "sets the user_id in the session" do
        post :create, email: "brandon@mrbarrette.com", password: "math1234"
        expect(session[:user_id]).to eq(user.id)
      end

      it "sets the flash success message" do
        post :create, email: "brandon@mrbarrette.com", password: "math1234"
        expect(flash[:success]).to eq("Thanks for logging in!")
      end

      it "sets the remember_me_token cookie if chosen" do
        expect(cookies).to_not have_key('remember_me_token')
        post :create, email: "brandon@mrbarrette.com", password: "math1234", remember_me: "1"
        expect(cookies).to have_key('remember_me_token')
        expect(cookies['remember_me_token']).to_not be nil
      end
    end

    shared_examples_for "denied login" do
      it "renders the new template" do
        post :create, email: email, password: password
        expect(response).to render_template('new')
      end

      it "sets the flash error message" do
        post :create, email: email, passowrd: password
        expect(flash[:error]).to eq("There was a problem logging in. Please check your e-mail and password.")
      end
    end

    context "with blank credentials" do
      let(:email) {""}
      let(:password) {""}
      it_behaves_like "denied login"
    end

    context "with an incorrect password" do
      let!(:user) { user = User.create(first_name: "Brandon", last_name: "Barrette", email: "brandon@mrbarrette.com", password: "math1234", password_confirmation: "math1234") }
      let(:email) {user.email}
      let(:password) {"math4321"}
      it_behaves_like "denied login"
    end

    context "with no email in existence" do
      let!(:user) { user = User.create(first_name: "Brandon", last_name: "Barrette", email: "brandon@mrbarrette.com", password: "math1234", password_confirmation: "math1234") }
      let(:email) {"hello@example.com"}
      let(:password) {user.password}
      it_behaves_like "denied login"
    end

    context "with an incorrect email and password" do
      let!(:user) { user = User.create(first_name: "Brandon", last_name: "Barrette", email: "brandon@mrbarrette.com", password: "math1234", password_confirmation: "math1234") }
      let(:email) {"hello@example.com"}
      let(:password) {"math4321"}
      it_behaves_like "denied login"
    end
  end #end Post Create

  describe "DELETE destroy" do
    context "logged in" do
      before do
        sign_in create(:user)
      end

      it "returns a redirect" do
        delete :destroy
        expect(response).to be_redirect
      end

      it "sets the flash message" do
        delete :destroy
        expect(flash[:notice]).to_not be_blank
        expect(flash[:notice]).to match(/logged out/)
      end

      it "removes the session[:user_id] key" do
        session[:user_id] = 1
        delete :destroy
        expect(session[:user_id]).to be_nil
      end

      it "removes the remember_me_token cookie" do
        cookies['remember_me_token'] = 'remembered'
        delete :destroy
        expect(cookies).to_not have_key('remember_me_token')
        expect(cookies['remember_me_token']).to be_nil
      end

      it "resets the session" do
        expect(controller).to receive(:reset_session)
        delete :destroy
      end
    end
  end


end
