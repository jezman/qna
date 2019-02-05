require 'rails_helper'

feature 'Subscribe to question' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  before { sign_in(user) }

  scenario 'User can subscribes for a question', js: true do
    visit question_path(question)

    click_on 'Subscribe'

    expect(page).to have_content 'Your subscribed.'
    expect(page).to_not have_link 'Subscribe'
  end
end
