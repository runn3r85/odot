require 'spec_helper'

describe "Creating todo items" do

  let!(:todo_list){ create(:todo_list) }
  before { sign_in(todo_list.user, password: "math1234") }

  def create_todo_item(options={})
    options[:content] ||= "Milk"

    visit_todo_list(todo_list)
    within ".global-header" do
      click_link "Add Todo Item"
    end
    expect(page).to have_content("Add Item to Todo List") 

    fill_in "Content", with: options[:content]
    click_button "Save"
  end

	it "is successful with valid content" do
    create_todo_item
		expect(page).to have_content("Added todo list item.")
		within(".todo-items") do
			expect(page).to have_content("Milk")
		end
	end


	it "displays an error with no content" do
		create_todo_item(content: " ")
		within("div.flash") do
			expect(page).to have_content("There was a problem adding that todo list item.")
		end
		expect(page).to have_content(/can't be blank/i)
	end


	it "displays an error with content less than 2 characters long" do
		create_todo_item(content: "m")
		within("div.flash") do
			expect(page).to have_content("There was a problem adding that todo list item.")
		end
		expect(page).to have_content(/is too short/i)
	end

end