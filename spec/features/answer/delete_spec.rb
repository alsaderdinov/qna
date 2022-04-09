require 'rails_helper'
feature 'User can delete own answer', "
  In order to delete answer
  As an authenticated user
  I'd like to delete own answer
" do
  given(:user) { create(:user) }
  given(:not_author) { create(:user) }
  given!(:question) { create(:question, user: not_author) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user', js: true do

    scenario 'delete hist answer' do
      sign_in(user)
      visit question_path(question)

      click_on 'Delete'
      page.driver.browser.switch_to.alert.accept

      expect(page).to have_content 'Your answer was successfully deleted.'
      expect(page).to_not have_content answer.body
    end

    scenario 'not author tries to delete answer' do
      sign_in(not_author)
      visit question_path(question)

      element = first('li', text: not_author.email)
      expect(element).to_not have_link 'Delete answer'
    end
  end

  scenario 'Unauthenticated user tries to delete answer' do
    visit question_path(question)
    expect(page).to_not have_content 'Delete answer'
  end
end
