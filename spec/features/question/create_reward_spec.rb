require 'rails_helper'

feature 'User can create reward', "
  In order to reward user for best answer
  As an author of question
  I'd like to be able add reward
" do
  describe 'User create reward with create question', js: true do
    given(:user) { create(:user) }

    background do
      sign_in(user)
      visit new_question_path
      fill_in 'Title', with: 'Question title'
      fill_in 'Body', with: 'Question body'
      fill_in 'Reward name', with: 'Question reward'
    end

    scenario 'with valid attributes' do
      attach_file 'Reward image', "#{Rails.root}/public/apple-touch-icon.png"

      click_on 'Ask question'

      expect(page).to have_content 'Question reward'
      expect(page).to have_css("img[src*='apple-touch-icon.png']")
    end

    scenario 'with invalid attributes' do
      click_on 'Ask question'

      expect(page).to have_content("Reward image can't be blank")
    end
  end
end
