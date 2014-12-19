FactoryGirl.define do
  factory :article do
    sequence(:title) { |n| "Article #{n}" }
    sequence(:slug) { |n| "article-#{n}-slug-#{Time.now.to_i}" }
    content { complex_markdown }

    factory :article_with_picture do

      transient do
        sequence(:file_slug) do |n|
          Faker::Lorem.characters(10) + "-#{n}"
        end
      end

      content { complex_markdown + "\n\n![](../#{file_slug}.png)"}
      after(:create) do |article, evaluator|
        FactoryGirl.create_list(:picture, 1, document: article, file_slug: evaluator.file_slug)
      end
    end

  end
end
