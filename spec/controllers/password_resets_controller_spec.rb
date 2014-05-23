require 'spec_helper'

describe PasswordResetsController do

  describe "GET new" do
    it "renders the new template" do
      get :new
      expect(response).to render_template("new")
    end
  end

  describe "POST create" do
    context "with a valid user and email" do
      let(:user) { create(:user) }

      it "finds the user" do
        expect(User).to receive(:find_by).with(email: user.email).and_return(user)
        post :create, email: user.email
      end

      it "generates a new passowrd reset token" do
        expect{ post :create, email: user.email; user.reload }.to change{ user.password_reset_token }
      end

      it "sends a password reset e-mail" do
        expect{ post :create, email: user.email }.to change(ActionMailer::Base.deliveries, :size)
      end

      it "sets the flash message" do
        post :create, email: user.email
        expect(flash[:success]).to match(/check your email/)
      end
    end

    context "with no user found" do

      it "renders the new page" do
        post :create, email: "none@found.com"
        expect(response).to render_template('new')
      end

      it "sets the flash message" do
        post :create, email: "none@found.com"
        expect(flash[:notice]).to match(/not found/)
      end

    end
  end


  describe "GET edit" do
    context "with a valid password_reset_token" do
      let(:user) { create(:user) }
      before { user.generate_password_reset_token! }

      it "renders the edit page" do
        get :edit, id: user.password_reset_token
        expect(response).to render_template("edit")
      end

      it "assigns @user" do
        get :edit, id: user.password_reset_token
        expect(assigns(:user)).to eq(user)
      end
    end

    context "with not password_reset_token found" do
      it "renders the 404 page" do
        get :edit, id: 'not found'
        expect(response.status).to eq(404)
        expect(response).to render_template(file: "#{Rails.root}/public/404.html")
      end
    end
  end

  describe "PATCH update" do
    context "with no token found" do
      it "renders the edit page" do
        patch :update, id: 'notfound', user: {password: "newpass", password_confirmation: "newpass" }
        expect(response).to render_template("edit")
      end

      it "sets the flash message" do
        patch :update, id: 'notfound', user: {password: "newpass", password_confirmation: "newpass" }
        expect(flash[:notice]).to match(/error resetting/)
      end
    end

    context "with a valid token" do
      let(:user) { create(:user) }
      before { user.generate_password_reset_token! }

      it "updates the users password" do
        digest = user.password_digest
        patch :update, id: user.password_reset_token, user: { password: "newpass", password_confirmation: "newpass" }
        user.reload
        expect(user.password_digest).to_not eq(digest)
      end

      it "clears the password_reset_token" do
        patch :update, id: user.password_reset_token, user: { password: "newpass", password_confirmation: "newpass" }
        user.reload
        expect(user.password_reset_token).to be_blank
      end

      it "sets the session[:user_id] to the user's id" do
        patch :update, id: user.password_reset_token, user: { password: "newpass", password_confirmation: "newpass" }
        expect(session[:user_id]).to eq(user.id)
      end

      it "sets the flash[:success] message" do
        patch :update, id: user.password_reset_token, user: { password: "newpass", password_confirmation: "newpass" }
        expect(flash[:success]).to match("Your password was successfully updated!")
      end

      it "redirect to todo_lists_path" do
        patch :update, id: user.password_reset_token, user: { password: "newpass", password_confirmation: "newpass" }
        expect(response).to redirect_to(todo_lists_path)
      end
    end
  end

end
