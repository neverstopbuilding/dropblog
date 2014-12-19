FactoryGirl.define do
  factory :article do
    sequence(:title) { |n| "Article #{n}" }
    sequence(:slug) { |n| "article-#{n}-slug-#{Time.now.to_i}" }
    content { complex_markdown }
  end
end
