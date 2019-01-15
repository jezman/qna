require 'rails_helper'

feature 'User can vote for a question', %q{
  In order to show that question is good
  As an authenticated user
  I'd like to be able to set 'like' for question.
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    before { sign_in(user) }
    before { visit question_path(question) }

    scenario 'can vote up' do
      within('.vote') do
        click_on '+'
        expect(page).to have_content '1'
      end
    end
  end
end
