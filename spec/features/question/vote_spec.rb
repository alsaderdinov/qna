require 'rails_helper'

feature 'User can vote for question', "
  In order to mark like or dislike question
  As an authenticated user
  I'd like to be able to vote for question
" do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }

  describe 'As not author of question', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'upvotes for question' do
      within '.question-votes' do
        find(:css, '.octicon-thumbsup').click
        expect(page).to have_content 'Rating: 1'
      end
    end

    scenario 'downvote for question' do
      within '.question-votes' do
        find(:css, '.octicon-thumbsdown').click
        expect(page).to have_content 'Rating: -1'
      end
    end

    scenario 'tries upvotes for question twice' do
      within '.question-votes' do
        find(:css, '.octicon-thumbsup').click
        find(:css, '.octicon-thumbsup').click
        expect(page).to have_content 'Rating: 1'
      end
    end

    scenario 'tries downvote for question twice' do
      within '.question-votes' do
        find(:css, '.octicon-thumbsdown').click
        find(:css, '.octicon-thumbsdown').click
        expect(page).to have_content 'Rating: -1'
      end
    end

    scenario 'canceling upvote for question' do
      within '.question-votes' do
        find(:css, '.octicon-thumbsup').click
        expect(page).to have_content 'Rating: 1'

        click_on 'Cancel vote'

        expect(page).to have_content 'Rating: 0'
      end
    end

    scenario 'canceling downvote for question' do
      within '.question-votes' do
        find(:css, '.octicon-thumbsdown').click
        expect(page).to have_content 'Rating: -1'

        click_on 'Cancel vote'

        expect(page).to have_content 'Rating: 0'
      end
    end
  end

  describe 'As an author of question', js: true do
    background do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'tries to upvote for his own question' do
      expect(page).to_not have_css('.octicon-thumbsup')
    end

    scenario 'tries to downvote for his own question' do
      expect(page).to_not have_css('.octicon-thumbsdown')
    end

    scenario 'tries to canceling votes for his own question' do
      expect(page).to_not have_link 'Cancel vote'
    end

    scenario 'Unauthenticated user tries to vote question' do
      visit question_path(question)
      within '.question-votes' do
        expect(page).to_not have_css('.octicon-thumbsdown')
        expect(page).to_not have_css('.octicon-thumbsup')
        expect(page).to_not have_link('Cancel vote')
      end
    end
  end
end
