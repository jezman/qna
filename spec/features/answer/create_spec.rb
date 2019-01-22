require 'rails_helper'

feature 'User can create answer', %q{
  As an authenticated user
  being on the question page
  can write the answer to the question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    before { sign_in(user) }
    before { visit question_path(question) }

    scenario 'answer the question' do
      fill_in 'Body', with: 'answer body'
      click_on 'Reply'

      expect(page).to have_content 'Your answers successfully created.'
      expect(page).to have_content 'answer body'
    end

    scenario 'answer the question with attach files' do
      fill_in 'Body', with: 'answer body'

      attach_files
      click_on 'Reply'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'answer the question with error' do
      click_on 'Reply'

      expect(page).to have_content "Body can't be blank"
    end

    context 'mulitple sessions', js: true do
      given(:some_url) { 'https://ya.ru' }

      scenario "question appears on another user's page" do
        Capybara.using_session('second_user') do
          second_user = create(:user)

          sign_in(second_user)
          visit question_path(question)
        end

        Capybara.using_session('user') do
          sign_in(user)
          visit question_path(question)

          fill_in 'Body', with: 'answer body'

          attach_files

          fill_in 'Link name', with: 'My link'
          fill_in 'Url', with: some_url

          click_on 'Reply'

          expect(page).to have_content 'answer body'
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end

        Capybara.using_session('second_user') do
          expect(page).to have_content 'answer body'
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
          expect(page).to have_link 'My link', href: some_url
        end
      end
    end
  end

  scenario 'Not authenticated user answer a question' do
    visit question_path(question)
    click_on 'Reply'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
