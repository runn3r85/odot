FactoryGirl.define do
  factory :user do
    first_name "First"
    last_name "Last"
    sequence :email do |n| 
      "user#{n}@mrbarrette.com"
    end
    password "math1234"
    password_confirmation "math1234"
  end
end