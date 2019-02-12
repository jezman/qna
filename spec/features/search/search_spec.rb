require 'rails_helper'

feature 'Search in questions, answers, comment and users' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:comment) { create(:comment, commentable: question, user: user) }

  describe 'User can search in', sphinx: true do
    before { visit root_path }

    Search::RESOURCES.each do |resource|
      scenario "#{resource.downcase} documents" do
        ThinkingSphinx::Test.run do
          fill_in :query, with: resource == 'User' ? 'domain' : 'Body'
          select resource, from: :resource
          click_on 'Find'

          within ".search-results .#{resource.downcase}" do
            expect(page).to have_content resource == 'User' ? user.email : 'Body'
          end
        end
      end
    end

    scenario 'all documents' do
      ThinkingSphinx::Test.run do
        within '.search-form' do
          select 'Everywhere', from: :resource
          fill_in :query, with: 'Body'
          click_on 'Find'
        end

        within '.search-results .question' do
          expect(page).to have_content 'Body'
        end

        within '.search-results .answer' do
          expect(page).to have_content 'Body'
        end

        within '.search-results .comment' do
          expect(page).to have_content 'Body'
        end
      end
    end
  end
end
