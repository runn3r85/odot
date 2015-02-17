require 'spec_helper'

describe "Editing todo lists" do

  # let(:user) { create(:user) }
  let!(:todo_list){ create(:todo_list) }
  before do
    sign_in(todo_list.user, password: "math1234")
  end

  def update_todo_list(options={})
    options[:title] ||= "New Title"

    todo_list = options[:todo_list]

    visit "/todo_lists"
    click_link todo_list.title
    click_link "Edit"
    fill_in "Title", with: options[:title]
    click_button "Save"
  end

  it "updates a todo list successfully with correct information" do
    update_todo_list(todo_list: todo_list)

    todo_list.reload

    expect(page).to have_content("Todo list was successfully updated")
    expect(todo_list.title).to eq("New Title")
  end


  it "displays an error with no title" do
    update_todo_list(todo_list: todo_list, title: "")
    expect(page).to have_content(/can't be blank/i)
  end

  it "displays an error with too short a title" do
    update_todo_list(todo_list: todo_list, title: "Hi")
    expect(page).to have_content(/too short/i)
  end
end