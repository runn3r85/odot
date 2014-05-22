require 'spec_helper'

describe "Creating todo lists" do

  let(:user) { create(:user) }

  def create_todo_list(options={})
    options[:title] ||= "My todo list"
    options[:description] ||= "This is my todo list."

    visit "/todo_lists"
    click_link "New Todo list"
    expect(page).to have_content("New todo_list") 

    fill_in "Title", with: options[:title]
    fill_in "Description", with: options[:description]
    click_button "Create Todo list"
  end

  before do
    sign_in(user, password: "math1234")
  end

  it "redirects to the todo list index page on success" do
    create_todo_list
    expect(page).to have_content("My todo list")
  end

  it "displays an error when the todo list has no title" do
    expect(TodoList.count).to eq(0)

    create_todo_list(title: "" )

    expect(TodoList.count).to eq(0)
    expect(page).to have_content("error")

    visit "/todo_lists"
    expect(page).to_not have_content("This is what I'm doing today")
  end


  it "displays an error when it has a title less than 3 characters" do
    expect(TodoList.count).to eq(0)

    create_todo_list(title: "Hi")

    expect(TodoList.count).to eq(0)
    expect(page).to have_content("error")

    visit "/todo_lists"
    expect(page).to_not have_content("This is what I'm doing today")
  end

  it "displays an error when the description is blank" do
    expect(TodoList.count).to eq(0)

    create_todo_list(description: "")

    expect(TodoList.count).to eq(0)
    expect(page).to have_content("error")

    visit "/todo_lists"
    expect(page).to_not have_content("This is what I'm doing today")
  end

  it "displays an error when it has a description less than 5 characters" do
    expect(TodoList.count).to eq(0)

    create_todo_list(description: "this")

    expect(TodoList.count).to eq(0)
    expect(page).to have_content("error")

    visit "/todo_lists"
    expect(page).to_not have_content("This is what I'm doing today")
  end
end