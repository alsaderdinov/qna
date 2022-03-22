require 'rails_helper'

feature 'User can view question', "
 In order to view question
 As an User
 I'd like to be able to see question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 3, question: question, user: user) }

  scenario 'User view question' do
    visit question_path(question)
    expect(page).to have_content(question.body)

    answers.each { |answer| expect(page).to have_content(answer.body) }
  end
end
