FactoryGirl.define do
  factory :project do
    sequence(:title) { |n| "Project #{n}" }
    sequence(:slug) { |n| Faker::Lorem.words(n, true).join('-') }
    content do
      content = ''
      4.times do
        content += "## #{Faker::Lorem.sentence}\n"
        content += Faker::Lorem.paragraph(2) + "\n"
      end
      content
    end
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
