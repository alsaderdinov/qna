require 'rails_helper'

feature 'User can create comments', "
  In order to discuss question
  As an authenticated user
  I'd like to be able to create comment
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'create comment' do
      within '.question' do
        fill_in 'Your comment', with: 'Test comment'
        click_on 'Add comment'
        expect(page).to have_content 'Test comment'
      end
    end

    scenario 'create comment with errors' do
      within '.question' do
        click_on 'Add comment'
        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  context 'multiple sessions', js: true do
    scenario "comment appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Your comment', with: 'Test comment'
        click_on 'Add comment'

        expect(page).to have_content 'Test comment'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test comment'
      end
    end
  end

  describe 'Unauthenticated user', js: true do
    background do
      visit question_path(question)
    end

    scenario 'tries to add comment' do
      within '.question' do
        fill_in 'Your comment', with: 'Test comment'
        click_on 'Add comment'
        expect(page).to_not have_content 'Test comment'
      end
    end
  end
end
