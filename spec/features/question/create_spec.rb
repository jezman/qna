require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
} do
  given!(:user) { create(:user) }

  describe 'Authenticated user' do
    before { sign_in(user)}

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

    scenario 'asc question with attach files' do
      fill_in 'Title', with: 'Question title'
      fill_in 'Body', with: 'Question body'

      attach_file 'File', ["#{Rails.root.join('spec/rails_helper.rb')}", "#{Rails.root.join('spec/spec_helper.rb').to_s}"]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Not authenticated user asks a question' do
    visit questions_path
    click_on 'New question'
    
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
