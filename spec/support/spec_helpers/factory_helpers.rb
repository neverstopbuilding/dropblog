module FactoryHelpers
  def complex_markdown
    content = ''

    content += "## #{Faker::Lorem.sentence}\n"
    2.times do
      content += Faker::Lorem.paragraph(10) + "\n"
      content += "\n"
    end

    content += "\n"

    content += "### #{Faker::Lorem.sentence}\n"
    3.times do
      content += "> #{Faker::Lorem.sentence}\n"
    end

    content += "\n"

    content += "#### #{Faker::Lorem.sentence}\n"
    5.times do
      content += "- #{Faker::Lorem.word}\n"
    end

    content += "\n"

    content += "#### #{Faker::Lorem.sentence}\n"
    5.times do |n|
      content += "#{n}. #{Faker::Lorem.word}\n"
    end

    content += "\n"

    content += "##### #{Faker::Lorem.sentence}\n"
    5.times do |n|
      content += "    #{Faker::Lorem.sentence}\n"
    end

    content += "\n"

    content += "###### #{Faker::Lorem.sentence}\n"

    content += "\n"

    content += "`#{Faker::Lorem.sentence}`\n"
  end
end
