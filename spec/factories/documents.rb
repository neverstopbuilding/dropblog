# FactoryGirl.define do
#   factory :document do
#     slug "MyString"
# title "MyString"
# content "MyText"
# type ""
# category "MyString"
# document nil
#   end

# end

FactoryGirl.define do
  factory :document do
    sequence(:title) { |n| "Document #{n}" }
    sequence(:slug) { |n| "document-#{n}-slug-#{Time.now.to_i}" }
    content { complex_markdown }
  end
end
