FactoryGirl.define do
  factory :picture do

    transient do
      sequence(:file_slug) do |n|
        Faker::Lorem.characters(10) + "-#{n}"
      end
    end

    file_name { "#{file_slug}.png"}
    public_path { Faker::Avatar.image(file_slug) }

    document

    factory :article_picture do
      association :document, factory: :article
    end

    factory :project_picture do
      association :document, factory: :project
    end
  end
end

