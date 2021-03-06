require 'spec_helper'

describe "Deleting todo lists" do

  let(:user) { create(:user) }
  let!(:todo_list){ create(:todo_list) }
  
  before do
    sign_in(todo_list.user, password: "math1234")
  end

  it "is successful when clicking destroy link" do
    visit "/todo_lists"
    click_link todo_list.title
    click_link "Delete"
    expect(page).to_not have_content(todo_list.title)
    expect(TodoList.count).to eq(0)
  end
end