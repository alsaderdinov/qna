require 'rails_helper'

feature 'User can view the questions', "
  In order to view questions
  As an user
  I'd like to be able to see questions
" do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3, user: user) }
  scenario 'User looks at questions' do
    visit questions_path

    questions.each { |question| expect(page).to have_content(question.title) }
  end
end
