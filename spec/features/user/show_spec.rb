require 'rails_helper'

feature 'User can view his profile', "
  In order to view his profile
  As an authenticated user
  I'd like to be able see my profile
" do
  given(:user) { create(:user, :with_rewards) }
  given(:user2) { create(:user) }

  scenario 'User tries see own rewards' do
    sign_in(user)
    visit user_path(user)
    reward = user.rewards.first

    expect(page).to_not have_content 'No rewards yet'
    expect(page).to have_content reward.question.title
    expect(page).to have_css("img[class*='card-imb-top']")
    expect(page).to have_content reward.name
  end

  scenario 'User tries to see other user rewards' do
    sign_in(user2)
    visit user_path(user)
    reward = user.rewards.first

    expect(page).to have_content 'No rewards yet'
    expect(page).to_not have_content reward.question.title
    expect(page).to_not have_css("img[class*='card-imb-top']")
    expect(page).to_not have_content reward.name
  end
end
