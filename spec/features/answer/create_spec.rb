require 'rails_helper'

feature 'User can create answer', "
  In order to create answer on question
  As an authenticated user
  I'd like to be able to create answer
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'create answer' do
      fill_in 'Body', with: 'test_answer'
      click_on 'Create answer'

      expect(page).to have_content 'Answer was successfully created'
      expect(page).to have_content 'test_answer'
    end

    scenario 'create answer with errros' do
      click_on 'Create answer'

      expect(page).to have_content("Body can't be blank")
    end
  end

  scenario 'Unauthenticated user tries to create answer' do
    visit question_path(question)
    fill_in 'Body', with: 'some_text'
    click_on 'Create answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
