require 'rails_helper'

feature 'User can log out', "
  As an authenticated user
  I'd like to be able to logout
" do
  given(:user) { create(:user) }
  background { visit new_user_session_path }

  scenario 'Authenticated user tries to log out' do
    sign_in(user)
    click_on 'Log out'

    expect(page).to have_content('Signed out successfully.')
  end
end
