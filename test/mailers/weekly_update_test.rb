require 'test_helper'

class WeeklyUpdateTest < ActionMailer::TestCase
  test "wips" do
    mail = WeeklyUpdate.wips
    assert_equal "Wips", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "completeds" do
    mail = WeeklyUpdate.completeds
    assert_equal "Completeds", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "blockers" do
    mail = WeeklyUpdate.blockers
    assert_equal "Blockers", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
