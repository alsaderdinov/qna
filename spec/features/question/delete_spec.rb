require 'rails_helper'

feature 'User can delete own question', "
  In order to delete question
  As an authenticated user
  I'd like to delete own question
" do
  given(:user) { create(:user) }
  given(:not_author) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    scenario 'delete own question' do
      sign_in(user)
      visit question_path(question)

      click_on 'Delete question'
      expect(page).to have_content 'Your question successfully deleted'
      expect(page).to_not have_content question.title
    end

    scenario 'not author tries delete question' do
      sign_in(not_author)
      visit question_path(question)

      expect(page).to_not have_content 'Delete question'
    end
  end

  scenario 'Not authenticated user tries to delete question' do
    visit question_path(question)
    expect(page).to_not have_content 'Delete question'
  end
end
