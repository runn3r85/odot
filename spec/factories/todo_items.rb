FactoryGirl.define do
  factory :todo_item do
    content "Todo Item Content"
    todo_list
  end
end