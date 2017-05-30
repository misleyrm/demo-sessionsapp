
module Features

  module SessionHelpers

    def signin(email, password)

      visit login_create_path
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      click_on 'Enter'

    end

  end

end
