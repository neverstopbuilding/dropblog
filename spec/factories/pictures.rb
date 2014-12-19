FactoryGirl.define do
  factory :article_picture, class: 'Picture' do
    sequence :file_name do |n|
      Faker::Lorem.characters(10) + "-#{n}.png"
    end

    path do
      Faker::Avatar.image(file_name[0..-5])
    end

    association :pictureable, factory: :article

    factory :project_picture, class: 'Picture' do
      association :pictureable, factory: :project
    end
  end

end
