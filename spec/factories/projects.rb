FactoryGirl.define do
  factory :project do
    sequence(:title) { |n| "Project #{n}" }
    sequence(:slug) { |n| "project-#{n}-slug-#{Time.now.to_i}" }
    content { complex_markdown }
    public true

    factory :private_project do
      public false
    end

    factory :project_with_articles do
      transient do
        articles_count 4
      end

      after(:create) do |project, evaluator|
        FactoryGirl.create_list(:article, evaluator.articles_count, project: project)
      end
    end
  end
end
