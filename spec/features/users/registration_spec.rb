require "spec_helper"

describe "Signing Up" do 

  it "allows a user to sign up for the site and creates the user in the database" do
    expect(User.count).to eq(0)
    visit "/"
    expect(page).to have_content("Sign Up")
    within(".hero-inner") { click_link "Sign Up" }

    fill_in "First Name", with: "Brandon"
    fill_in "Last Name", with: "Barrette"
    fill_in "Email", with: "brandon@mrbarrette.com"
    fill_in "Password", with: "math1234"
    fill_in "Password (again)", with: "math1234"

    click_button "Sign Up"
    expect(User.count).to eq(1)
  end

  it "displays a tutorial when the user signs up" do
    visit "/"
    within(".hero-inner") { click_link "Sign Up" }

    fill_in "First Name", with: "Brandon"
    fill_in "Last Name", with: "Barrette"
    fill_in "Email", with: "brandon@mrbarrette.com"
    fill_in "Password", with: "math1234"
    fill_in "Password (again)", with: "math1234"

    click_button "Sign Up"

    expect(page).to have_content("ODOT Tutorial")
    click_on "ODOT Tutorial"

    expect(page.all("li.todo-item").size).to eq(7)
  end

end