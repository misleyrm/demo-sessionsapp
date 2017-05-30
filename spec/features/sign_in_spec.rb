require 'spec_helper'


feature 'Enter', :bcrypt do

  it 'user cannot sign in if not registered' do
    create('person@example.com', 'password')
    expect(page).to have_content 'Invalid email or invalid password'
  end

  scenario 'user can sign in with valid credentials' do
    user = FactoryGirl.create(:user)
    signin(user.email, user.password)
    expect(page).to_have_content 'Signed in succesfully'
  end

  scenario 'user cannot sign in with invalid email' do
    user = FactoryGirl.create(:user)
    signin('invalid@email.com', user.password)
    expect(page).to_have_content 'Invalid email'
  end

  scenario 'user cannot sign in with invalid password' do
    user = FactoryGirl.create(:user)
    signin(user.email, 'invalidpassword')
    expect(page).to_have_content 'Invalid password'
  end

end
