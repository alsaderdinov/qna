require 'rails_helper'
feature 'User can edit his question', "
  In order to correct mistakes
  As an authenticated user
  I'd like to be able to edit my question
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:not_author) { create(:user) }
  given(:link) { 'https://example.com' }

  scenario 'Unauthenticated user cannot update question', js: true do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end

  scenario 'Not author tries to update other user question', js: true do
    sign_in(not_author)
    visit question_path(question)
    expect(page).to_not have_content 'Edit'
  end

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit'
    end

    scenario 'Update his question' do
      within '.question' do
        fill_in 'Your question', with: 'updated question'
        click_on 'save'
        expect(page).to_not have_content question.body
        expect(page).to have_content 'updated question'
      end
      expect(page).to have_content 'Your question was successfully updated.'
    end

    scenario 'Update his question with attached file' do
      within '.question' do
        fill_in 'Your question', with: 'updated question'
        attach_file 'File', %W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb]
        click_on 'save'
        expect(page).to have_link 'spec_helper.rb'
        expect(page).to have_link 'rails_helper.rb'
      end
    end

    scenario 'Update his question with added link' do
      within '.question' do
        click_on 'Add link'

        fill_in 'Link name', with: 'Example link'
        fill_in 'Url', with: link

        click_on 'save'

        expect(page).to have_link 'Example link', href: link
      end
    end

    scenario 'Update his question with errors' do
      within '.question' do
        fill_in 'Your question', with: ''
        click_on 'save'
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario 'delete attachment' do
      within '.question' do
        attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
        click_on 'save'

        find(:css, '.octicon-x').click
        page.driver.browser.switch_to.alert.accept
        expect(page).to_not have_link 'rails_helper.rb'
      end
      expect(page).to have_content 'Your attachment was successfully deleted'
    end
  end
end
