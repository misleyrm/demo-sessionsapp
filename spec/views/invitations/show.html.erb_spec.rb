require 'rails_helper'

RSpec.describe "invitations/show", type: :view do
  before(:each) do
    @invitation = assign(:invitation, Invitation.create!(
      :sender_id => 2,
      :list_id => 3,
      :recipient_email => "Recipient Email",
      :token => "Token"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/Recipient Email/)
    expect(rendered).to match(/Token/)
  end
end
