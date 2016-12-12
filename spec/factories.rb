FactoryGirl.define do
  factory :room do
    number 1
    name  "Test room"
  end

  factory :booking do
    start Date.today
    add_attribute :end, Date.today+7
    room FactoryGirl.create(:room)
  end
end
