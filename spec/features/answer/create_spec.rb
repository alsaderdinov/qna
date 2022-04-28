require 'rails_helper'

feature 'User can create answer', "
  In order to create answer on question
  As an authenticated user
  I'd like to be able to create answer
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'create answer' do
      fill_in 'Your answer', with: 'test_answer'
      click_on 'Create answer'

      expect(page).to have_content 'Your answer was successfully created.'
      expect(page).to have_content 'test_answer'
    end

    scenario 'create answer with errors' do
      click_on 'Create answer'

      expect(page).to have_content("Body can't be blank")
    end

    scenario 'create answer with attached file' do
      fill_in 'Your answer', with: 'test_answer'
      attach_file 'File', %W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb]

      click_on 'Create answer'
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  context 'multiple sessions', js: true do
    scenario "answers appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Your answer', with: 'test_answer'
        click_on 'Create answer'

        expect(page).to have_content 'Your answer was successfully created.'
        expect(page).to have_content 'test_answer'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'test_answer'
      end
    end
  end

  scenario 'Unauthenticated user tries to create answer' do
    visit question_path(question)
    fill_in 'Your answer', with: 'some_text'
    click_on 'Create answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
