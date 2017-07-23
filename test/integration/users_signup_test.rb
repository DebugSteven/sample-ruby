require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get signup_path
    if assert_select "form[action=\"#{signup_path}\"]"
      assert_no_difference 'User.count' do
        post signup_path, params: { user: { name:  "",
                                            email: "user@invalid",
                                            password:              "foo",
                                            password_confirmation: "bar" 
                                          } 
                                  }
      end
    end
    assert_template 'users/new'
    assert_select '#error_explanation' 
    assert_select '.field_with_errors'
  end

  test "valid signup information" do
    get signup_path
    if assert_select "form[action=\"#{signup_path}\"]"
      assert_difference 'User.count', 1 do
        post signup_path, params: { user: { name: "test",
                                            email: "user@valid.com",
                                            password: "foobar",
                                            password_confirmation: "foobar"
                                          }
        
                                  }
      end
      follow_redirect!
      assert_template 'users/show'
      assert_select 'div.alert-success', flash[:success]
    end
  end
end
