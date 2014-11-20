FactoryGirl.define do
  factory :article do
    sequence(:title) {|n| "Article #{n}"}
    sequence(:slug) { |n| Faker::Lorem.words(n, true).join('-') }
    content do
      content = ''
      3.times do
        content += "## #{Faker::Lorem.sentence}\n"
        content += Faker::Lorem.paragraph(2) + "\n"
      end
      content
    end
    public true

    factory :private_article do
      public false
    end
  end
end
