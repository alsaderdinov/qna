require 'rails_helper'

feature 'User can add answer', "
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
" do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:yandex_url) { 'https://yandex.ru' }
  given(:google_url) { 'https://google.com' }
  given(:invalid_url) { 'example.com' }
  given(:gist_url) { 'https://gist.github.com/flllck/9d7bda836cc2094462ca2a9d48bac652' }

  describe 'User adds link when give answer', js: true do
    background do
      sign_in(user)
      visit question_path(question)

      fill_in 'Your answer', with: 'My answer'
    end

    scenario 'with valid link' do

      fill_in 'Link name', with: 'Yandex'
      fill_in 'Url', with: yandex_url

      click_on 'Add link'

      within all('.nested-fields').last do
        fill_in 'Link name', with: 'Google'
        fill_in 'Url', with: google_url
      end

      click_on 'Create answer'

      within '.answers' do
        expect(page).to have_link 'Yandex', href: yandex_url
        expect(page).to have_link 'Google', href: google_url
      end
    end

    scenario 'with create gist' do
      fill_in 'Link name', with: 'My Gist'
      fill_in 'Url', with: gist_url

      click_on 'Create answer'

      within '.answers' do
        expect(page).to_not have_link 'My gist', href: gist_url
      end
    end

    scenario 'with invalid link' do
      fill_in 'Link name', with: 'Invalid'
      fill_in 'Url', with: invalid_url

      click_on 'Create answer'

      expect(page).to have_content 'Links url is invalid'
      expect(page).to_not have_link 'Invalid', href: invalid_url
    end
  end
end
