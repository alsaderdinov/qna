require 'rails_helper'

feature 'User can add answer', "
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
" do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:gist_url) { 'https://gist.github.com/flllck/9d7bda836cc2094462ca2a9d48bac652' }

  scenario 'User adds link when give answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Your answer', with: 'My answer'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Create'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
