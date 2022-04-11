require 'rails_helper'
feature 'User can edit his answer', "
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
" do
  given!(:user) { create(:user) }
  given!(:not_author) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated user cannot edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    scenario 'edits his answer' do
      sign_in(user)
      visit question_path(question)
      within '.answers-list' do
        click_on 'Edit'
        fill_in 'Your answer', with: 'edited answer'
        click_on 'save'
        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
      expect(page).to have_content 'Your answer was succesfully updated.'
    end

    scenario 'edits his answer with errors' do
      sign_in(user)
      visit question_path(question)
      within '.answers-list' do
        click_on 'Edit'
        fill_in 'Your answer', with: ''
        click_on 'save'
        expect(page).to have_content answer.body
        expect(page).to have_content "Body can't be blank"
      end
      expect(page).to have_content 'Fail answer update.'
    end

    scenario 'tries to edit other user answer' do
      sign_in(not_author)
      visit question_path(question)
      expect(page).to_not have_link 'Edit'
    end
  end
end
