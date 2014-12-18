FactoryGirl.define do
  factory :article do
    sequence(:title) { |n| "Article #{n}" }
    sequence(:slug) { |n| "article-#{n}-slug-#{Time.now.to_i}" }
    content { complex_markdown }
    public true
    factory :private_article do
      public false
    end
  end
end
