require 'spec_helper'

describe "Deleting todo items" do
  let!(:todo_item) { create(:todo_item) }
  let!(:todo_list){ todo_item.todo_list }
  before { sign_in(todo_list.user, password: "math1234") }

  it "is successful" do
  	visit_todo_list(todo_list)
  	within "#todo_item_#{todo_item.id}" do
  		click_link "Delete"
  	end
  	expect(page).to have_content("Todo list item was deleted.")
  	expect(TodoItem.count).to eq(0)
  end

end