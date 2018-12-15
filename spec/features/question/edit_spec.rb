require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be edit my question
} do

  given!(:user) { create(:user) }
  given!(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Unauthenticated can not edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

  describe 'Authenticated question' do
    scenario 'edits his question', js: true do
      sign_in user
      visit question_path(question)

      click_on 'Edit question'

      within '.question' do
        fill_in 'Your title', with: 'Question title'
        fill_in 'Your body', with: 'Question body'
        click_on 'Save'

        expect(page).to_not have_content question.body
        expect(page).to_not have_content question.title
        expect(page).to have_content 'Question title'
        expect(page).to have_content 'Question body'
        expect(page).to_not have_selector 'textfield'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his question with errors', js: true do
      sign_in user
      visit question_path(question)

      click_on 'Edit question'

      within '.question' do
        fill_in 'Your title', with: ''
        fill_in 'Your body', with: ''
        click_on 'Save'

        expect(page).to have_content question.body
        expect(page).to have_content question.title
        expect(page).to have_content "Body can't be blank"
        expect(page).to have_content "Title can't be blank"
        expect(page).to have_selector 'input'
        expect(page).to have_selector 'textarea'
      end
    end

    scenario "tries to edit other user's question" do
      sign_in another_user
      visit question_path(question)

      expect(page).to_not have_link 'Edit question'
    end
  end
end
