FactoryGirl.define do
  factory :todo_list do
    title "Todo List Title"
    description "Todo List Description"
    user
  end
end