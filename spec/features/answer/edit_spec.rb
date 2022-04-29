require 'rails_helper'
feature 'User can edit his answer', "
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
" do
  given(:user) { create(:user) }
  given(:not_author) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given(:link) { 'https://example.com' }

  scenario 'Unauthenticated user cannot edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'update his answer' do
      within '.answers-list' do
        click_on 'Edit'
        fill_in 'Your answer', with: 'updated answer'
        click_on 'save'
        expect(page).to_not have_content answer.body
        expect(page).to have_content 'updated answer'
      end
      expect(page).to have_content 'Your answer was successfully updated.'
    end

    scenario 'update his answer with attached file' do
      within '.answers-list' do
        click_on 'Edit'
        fill_in 'Your answer', with: 'updated answer'
        attach_file 'File', %W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb]
        click_on 'save'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'Update his question with added link' do
      within '.answers-list' do
        click_on 'Edit'

        click_on 'Add link'

        fill_in 'Link name', with: 'Example link'
        fill_in 'Url', with: link

        click_on 'save'

        expect(page).to have_link 'Example link', href: link
      end
    end

    scenario 'delete attachments' do
      within '.answers-list' do
        click_on 'Edit'
        attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
        click_on 'save'

        find(:css, '.octicon-x').click
        page.driver.browser.switch_to.alert.accept
        expect(page).to_not have_link 'rails_helper.rb'
      end
      expect(page).to have_content 'Your attachment was successfully deleted'
    end

    scenario 'update his answer with errors' do
      within '.answers-list' do
        click_on 'Edit'
        fill_in 'Your answer', with: ''
        click_on 'save'
        expect(page).to have_content answer.body
        expect(page).to have_content "Body can't be blank"
      end
      expect(page).to have_content 'Fail answer update.'
    end
  end

  scenario 'Not author tries to update other user answer' do
    sign_in(not_author)
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end
end
