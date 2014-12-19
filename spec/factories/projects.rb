FactoryGirl.define do
  factory :project do
    sequence(:title) { |n| "Project #{n}" }
    sequence(:slug) { |n| "project-#{n}-slug-#{Time.now.to_i}" }
    content { complex_markdown }

    factory :project_with_articles do
      transient do
        articles_count 4
      end

      after(:create) do |project, evaluator|
        FactoryGirl.create_list(:article, evaluator.articles_count, project: project)
      end
    end

    factory :project_with_picture do

      transient do
        sequence(:file_slug) do |n|
          Faker::Lorem.characters(10) + "-#{n}"
        end
      end

      content { complex_markdown + "\n\n![](../#{file_slug}.png)"}
      after(:create) do |project, evaluator|
        FactoryGirl.create_list(:picture, 1, document: project, file_slug: evaluator.file_slug)
      end
    end

    factory :project_with_picture_article do
      transient do
        sequence(:file_slug) do |n|
          Faker::Lorem.characters(10) + "-#{n}"
        end

        article_content { complex_markdown + "\n\n![](../#{file_slug}.png)"}
      end

      after(:create) do |project, evaluator|
        FactoryGirl.create_list(:article, 1, project: project, content: evaluator.article_content)
        FactoryGirl.create_list(:picture, 1, document: project, file_slug: evaluator.file_slug)
      end

    end
  end
end
