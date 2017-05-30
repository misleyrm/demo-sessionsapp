require 'rails_helper'

RSpec.describe "invitations/index", type: :view do
  before(:each) do
    assign(:invitations, [
      Invitation.create!(
        :sender_id => 2,
        :list_id => 3,
        :recipient_email => "Recipient Email",
        :token => "Token"
      ),
      Invitation.create!(
        :sender_id => 2,
        :list_id => 3,
        :recipient_email => "Recipient Email",
        :token => "Token"
      )
    ])
  end

  it "renders a list of invitations" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "Recipient Email".to_s, :count => 2
    assert_select "tr>td", :text => "Token".to_s, :count => 2
  end
end
