require 'rails_helper'

feature 'User can authorization with oauth providers' do
  let(:user) { create(:user, email: User::TEMPORARY_EMAIL) }
  let(:realy_email) { 'realy@email.address' }

  describe 'vkontakte' do
    scenario 'sign up user' do
      visit new_user_session_path

      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Email comfirmation'

      fill_in 'user_email', with: realy_email
      click_on 'Send confirmation'

      open_email(realy_email)
      current_email.click_link 'Confirm my account'

      expect(page).to have_content('Your email address has been successfully confirmed.')

      visit root_path
      expect(page).to have_content(realy_email)
    end

    scenario 'log in user' do
      auth = mock_auth_hash(:vkontakte, realy_email)

      create(:authorization, user: user, provider: auth.provider, uid: auth.uid)

      visit new_user_session_path
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content('Successfully authenticated from Vkontakte account.')
    end
  end

  describe 'github' do
    let(:new_user) { create(:user) }

    scenario 'log in user' do
      auth = mock_auth_hash(:github, new_user.email)

      create(:authorization, user: new_user, provider: auth.provider, uid: auth.uid)

      visit new_user_session_path
      click_on 'Sign in with GitHub'

      expect(page).to have_content(new_user.email)
    end
  end
end
