require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
} do
  given!(:user) { create(:user) }

  describe 'Authenticated user' do
    before { sign_in(user) }

    before do
      visit questions_path
      click_on 'New question'
    end

    scenario 'asks a question' do
      fill_in 'Title', with: 'Question title'
      fill_in 'Body', with: 'Question body'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content user.questions.last.title
      expect(page).to have_content user.questions.last.body
    end

    scenario 'ask question with attach files' do
      fill_in 'Title', with: 'Question title'
      fill_in 'Body', with: 'Question body'

      attach_files
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'ask question with badge' do
      fill_in 'Title', with: 'Question title'
      fill_in 'Body', with: 'Question body'

      fill_in 'Badge title', with: 'Very best answer'
      attach_file 'Image', Rails.root.join('app/assets/images/badges/default.png').to_s

      click_on 'Ask'

      expect(page).to have_content 'Very best answer'
      expect(page).to have_css("img[src*='default.png']")
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end
  end

  context 'mulitple sessions', js: true do
    scenario "question appears on another user's page" do
      Capybara.using_session('second_user') do
        second_user = create(:user)

        sign_in(second_user)
        visit questions_path
      end

      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path

        click_on 'New question'
        fill_in 'Title', with: 'Question title'
        fill_in 'Body', with: 'Question body'
        click_on 'Ask'

        expect(page).to have_content 'Question title'
        expect(page).to have_content 'Question body'
      end

      Capybara.using_session('second_user') do
        expect(page).to have_content 'Question title'
      end
    end
  end

  scenario 'Not authenticated user asks a question' do
    visit questions_path
    click_on 'New question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
