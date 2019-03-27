FactoryBot.define do
  factory :time_schedule do
    day { Date::DAYNAMES.first }
    period_start { Time.current.beginning_of_day }
    period_end { Time.current.end_of_day }
    timezone { "London" }
    closed { false }

    trait :spain do
      timezone { "Madrid" }
    end
  end
end
