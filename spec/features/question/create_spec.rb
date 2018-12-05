require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
} do
  given(:user) { create(:user) }

  scenario 'Authenticated user asks a question' do
    sign_in(user)

    visit questions_path
    click_on 'New question'

    fill_in 'Title', with: 'Question title'
    fill_in 'Body', with: 'Question body'
    click_on 'Ask'

    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content user.questions.last.title
    expect(page).to have_content user.questions.last.body
  end

  scenario 'Authenticated user asks a question with errors' do
    sign_in(user)

    visit questions_path
    click_on 'New question'
    click_on 'Ask'

    expect(page).to have_content "Title can't be blank"
    expect(page).to have_content "Body can't be blank"
  end

  scenario 'Not authenticated user asks a question' do
    visit questions_path
    click_on 'New question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
