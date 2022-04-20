require 'rails_helper'

feature 'Author can delete question links', "
  As an question's author
  I'd like to be able to delete links
" do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:link) { create(:link, linkable: question) }

  describe 'Authenticated user', js: true do
    scenario 'author tries to delete question links' do
      sign_in(user)
      visit question_path(question)

      click_on 'Delete link'

      expect(page).to have_content 'Your link was successfully deleted.'
      expect(page).to_not have_link link.name, href: link
    end

    scenario 'not author tries to' do
      sign_in(user2)
      visit question_path(question)

      expect(page).to_not have_link 'Delete link'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to delete question links' do
      visit question_path(question)

      expect(page).to_not have_link 'Delete link'
    end
  end
end
