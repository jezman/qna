require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be edit my question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Unauthenticated can not edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

  scenario "tries to edit other user's question" do
    another_user = create(:user)
    sign_in(another_user)

    visit question_path(question)

    expect(page).to_not have_selector 'file'
    expect(page).to_not have_link 'Edit question'
  end

  describe 'Authenticated user', js: true do
    before { sign_in user }
    before do
      visit question_path(question)
      click_on 'Edit question'
    end

    scenario 'edits his question' do
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

    scenario 'edits his question with attach files' do
      within '.question' do
        fill_in 'Your title', with: 'Question title'
        fill_in 'Your body', with: 'Question body'

        attach_file 'File', ["#{Rails.root.join('spec/rails_helper.rb')}", "#{Rails.root.join('spec/spec_helper.rb').to_s}"]
        click_on 'Save'

        expect(page).to_not have_selector 'file'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'edits his question be adding a link' do
      within '.question' do
        click_on 'add link'

        fill_in 'Link name', with: 'Thinknetica'
        fill_in 'Url', with: "http://thinknetica.com"

        click_on 'Save'

        expect(page).to have_link 'Thinknetica', href: "http://thinknetica.com"
        expect(page).to_not have_selector 'textfield'
      end
    end

    scenario 'edits his question with errors' do
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
  end
end
