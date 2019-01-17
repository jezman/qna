require 'rails_helper'

feature 'User can vote for a question', %q{
  In order to show that question is good
  As an authenticated user
  I'd like to be able to set 'like' for question.
} do
  given(:liker) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }

  describe 'Authenticated user', js: true do
    before { sign_in(liker) }
    before { visit question_path(question) }

    scenario 'can vote up' do
      within '.vote' do
        click_on '+'
        expect(page).to have_content '1'
      end
    end

    scenario 'can vote down' do
      within '.vote' do
        click_on '-'
        expect(page).to have_content '-1'
      end
    end

    scenario 'can vote only once' do
      within '.vote' do
        click_on '+'
        expect(page).to_not have_link '+'
        expect(page).to_not have_link '-'
      end
    end

    scenario 'can revote' do
      within '.vote' do
        click_on '+'
        expect(page).to have_link 'revoke'

        click_on 'revoke'
        expect(page).to have_content '0'
        expect(page).to_not have_link 'revoke'
      end
    end

    scenario "can't vote for self question" do
      click_on 'Log out'
      sign_in(author)

      expect(page).to_not have_link '+'
      expect(page).to_not have_link '-'
    end
  end
end
