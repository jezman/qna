require 'rails_helper'

feature 'Best answer', %q{
  to cheese the answer which is the best
  As an authenticated user
  I want to be able to set best answer to my question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:first_answer) { create(:answer, question: question, user: user) }
  given!(:second_answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated user or non question author can not set best answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Choose the best'
  end

  describe 'Authenticated user is question author', js: true do
    before { sign_in user }
    before { visit question_path(question) }

    scenario 'link to choose the best answer available' do
      expect(page).to have_link 'Choose the best'
    end

    scenario 'best answer link not available for best answer' do
      within(".answer-#{first_answer.id}") do
        click_on 'Choose the best'

        expect(page).to_not have_link 'Choose the best'
      end

      within(".answer-#{second_answer.id}") do
        expect(page).to have_link 'Choose the best'
      end
    end

    scenario 'can change the best answer' do
      within(".answer-#{second_answer.id}") do
        click_on 'Choose the best'

        expect(page).to_not have_link 'Choose the best'
      end

      within(".answer-#{first_answer.id}") do
        expect(page).to have_link 'Choose the best'
      end
    end
  end
end
