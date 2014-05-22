require 'spec_helper'

describe "Editing todo lists" do

  # let(:user) { create(:user) }
  let!(:todo_list){ create(:todo_list) }
  before do
    sign_in(todo_list.user, password: "math1234")
  end

  def update_todo_list(options={})
    options[:title] ||= "New Title"
    options[:description] ||= "New Description"

    todo_list = options[:todo_list]

    visit "/todo_lists"
    within "#todo_list_#{todo_list.id}" do
    	click_link "Edit"
    end
    fill_in "Title", with: options[:title]
    fill_in "Description", with: options[:description]
    click_button "Update Todo list"
  end

  it "updates a todo list successfully with correct information" do
    update_todo_list(todo_list: todo_list)

    todo_list.reload

    expect(page).to have_content("Todo list was successfully updated")
    expect(todo_list.title).to eq("New Title")
    expect(todo_list.description).to eq("New Description")
  end


  it "displays an error with no title" do
    update_todo_list(todo_list: todo_list, title: "")
    expect(page).to have_content("error")
  end

  it "displays an error with too short a title" do
    update_todo_list(todo_list: todo_list, title: "Hi")
    expect(page).to have_content("error")
  end

  it "displays an error with no description" do
    update_todo_list(todo_list: todo_list, description: "")
    expect(page).to have_content("error")
  end

  it "displays an error with too short a description" do
    update_todo_list(todo_list: todo_list, description: "this")
    expect(page).to have_content("error")
  end
end