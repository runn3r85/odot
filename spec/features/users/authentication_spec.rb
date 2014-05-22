require "spec_helper"

describe "Logging In" do
  it "logs the user in and goes to the todo lists" do
    User.create(first_name: "Brandon", last_name: "Barrette", email: "brandon@mrbarrette.com", password: "math1234", password_confirmation: "math1234")
    visit new_user_session_path
    fill_in "Email Address", with: "brandon@mrbarrette.com"
    fill_in "Password", with: "math1234"
    click_button "Sign In"

    expect(page).to have_content("Todo Lists")
    expect(page).to have_content("Thanks for logging in!")

  end


  it "displays the email address in the event of a failed login" do
    visit new_user_session_path
    fill_in "Email Address", with: "brandon@mrbarrette.com"
    fill_in "Password", with: "incorrect"
    click_button "Sign In"

    expect(page).to have_content("Please check your e-mail and password.")
    expect(page).to have_field("Email Address", with: "brandon@mrbarrette.com")
  end
end