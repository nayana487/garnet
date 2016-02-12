FactoryGirl.define do
  factory :cohort do
    course
    location

    sequence(:name) { |n| "cohort #{n}"}
    start_date { Date.today }
    end_date { Date.today + 3.months }
  end

end
