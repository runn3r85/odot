require 'spec_helper'

describe "Editing todo items" do
  let!(:todo_item) { create(:todo_item) }
  let!(:todo_list){ todo_item.todo_list }
  before { sign_in(todo_list.user, password: "math1234") }

  it "is successful with valid content" do
    visit_todo_list(todo_list)
    within("#todo_item_#{todo_item.id}") do
      click_link todo_item.content
    end
    fill_in "Content", with: "Lots of Milk"
    click_button "Save"
    expect(page).to have_content("Saved todo list item.")
    todo_item.reload
    expect(todo_item.content).to eq("Lots of Milk")
  end

  it "is unsuccessful with no content" do
    visit_todo_list(todo_list)
    within("#todo_item_#{todo_item.id}") do
      click_link todo_item.content
    end
    fill_in "Content", with: ""
    click_button "Save"
    expect(page).to_not have_content("Saved todo list item.")
    expect(page).to have_content(/can't be blank/i)
    todo_item.reload
    expect(todo_item.content).to eq(todo_item.content)
  end

  it "is unsuccessful with not enough content" do
    visit_todo_list(todo_list)
    within("#todo_item_#{todo_item.id}") do
      click_link todo_item.content
    end
    fill_in "Content", with: "1"
    click_button "Save"
    expect(page).to_not have_content("Saved todo list item.")
    expect(page).to have_content(/is too short/i)
    todo_item.reload
    expect(todo_item.content).to eq(todo_item.content)
  end




end