require 'rails_helper'

RSpec.describe "invitations/edit", type: :view do
  before(:each) do
    @invitation = assign(:invitation, Invitation.create!(
      :sender_id => 1,
      :list_id => 1,
      :recipient_email => "MyString",
      :token => "MyString"
    ))
  end

  it "renders the edit invitation form" do
    render

    assert_select "form[action=?][method=?]", invitation_path(@invitation), "post" do

      assert_select "input#invitation_sender_id[name=?]", "invitation[sender_id]"

      assert_select "input#invitation_list_id[name=?]", "invitation[list_id]"

      assert_select "input#invitation_recipient_email[name=?]", "invitation[recipient_email]"

      assert_select "input#invitation_token[name=?]", "invitation[token]"
    end
  end
end
