require 'rails_helper'

feature 'User can select best answer', "
  User can select best answer for question
  As author of question
  I'd like to be able to select best answer
" do
  given(:user) { create(:user) }
  given(:not_author) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 3, question: question, user: user) }

  describe 'Authenitcated user as author', js: true do
    before do
      sign_in(user)
      visit question_path(question)
    end
    scenario 'select best answer' do
      answer = answers[1]
      within "li[data-answer-id='#{answer.id}']" do
        click_on 'Select as best answer'
        expect(page).to have_content 'Best answer'
      end
    end

    scenario 'select another answer as best' do
      answer = answers[2]
      within "li[data-answer-id='#{answer.id}']" do
        click_on 'Select as best answer'
        expect(page).to have_content 'Best answer'
      end
    end
  end

  describe 'Authenticated user as not author', js: true do
    scenario 'select best answer' do
      sign_in(not_author)
      visit question_path(question)
      answer = answers[0]
      within "li[data-answer-id='#{answer.id}']" do
        expect(page).to_not have_content 'Select as best answer'
      end
    end
  end

  describe 'Unauthenticated user', js: true do
    scenario 'tries to select best answer' do
      visit question_path(question)
      expect(page).to_not have_content 'Select as best answer'
    end
  end
end
