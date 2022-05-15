require 'rails_helper'

feature 'User can subscribe to question', "
  In order to get notifications when new answers is created
  As an authenticated user
  I'd like to be able subscribe and unsubscribe to question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Author of question', js: true do

    scenario 'unsubscribe from question' do
      sign_in(user)
      visit question_path(question)

      expect(page).to have_content 'Unsubscribe'
      expect(page).to_not have_content 'Subscribe'

      click_on 'Unsubscribe'

      expect(page).to_not have_content 'Unsubscribe'
      expect(page).to have_content 'Subscribe'
    end
  end

  describe 'Not author of question', js: true do
    given(:not_author) { create(:user) }

    scenario 'subscribe to question' do
      sign_in(not_author)
      visit question_path(question)

      expect(page).to_not have_content 'Unsubscribe'
      expect(page).to have_content 'Subscribe'

      click_on 'Subscribe'

      expect(page).to have_content 'Unsubscribe'
      expect(page).to_not have_content 'Subscribe'
    end
  end

  scenario 'Unauthenticated user' do
    visit question_path(question)

    expect(page).to_not have_content 'Unsubscribe'
    expect(page).to_not have_content 'Subscribe'
  end
end
