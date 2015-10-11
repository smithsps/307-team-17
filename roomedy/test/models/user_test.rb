require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Derek Schrag", email: "dschrag@purdue.edu",
                                          houseID: 3, password: "testpasss",
                                          password_confirmation: "testpasss")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "    "
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 256
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                              first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                              foo@bar_baz.com foo@bar+bas.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "users should have unique email addresses" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.downcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "password is not blank" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  # Tests password for length <= 6
  test "password has minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?, puts(@user.password)
  end
end
