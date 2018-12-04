require 'rails_helper.rb'

feature 'User can create answer', %q{
  The user, being on the question page
  can write the answer to the question
} do
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'answer the question' do
    visit question_path(question)

    fill_in 'Body', with: answer.body
    click_on 'Reply'

    expect(page).to have_content 'Your answers successfully created.'
    expect(page).to have_content answer.body
  end

  scenario 'answer the question with error' do
    visit question_path(question)

    click_on 'Reply'

    expect(page).to have_content "Body can't be blank"
  end
end
