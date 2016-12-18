# frozen_string_literal: true
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'must have a github id' do
    user = users(:andrew)
    user.github_id = nil
    refute user.valid?
  end

  test 'must have a unique github_id' do
    user = User.create(github_id: users(:andrew), access_token: 'abcdefg')
    refute user.valid?
  end

  test 'must have an access_token' do
    user = users(:andrew)
    user.access_token = nil
    refute user.valid?
  end

  test 'must have a unique access_token' do
    user = User.create(github_id: 42, access_token: users(:andrew).access_token)
    refute user.valid?
  end

  test '.find_by_auth_hash finds a User by their github_id' do
    omniauth_config     = OmniAuth.config.mock_auth[:github]
    omniauth_config.uid = users(:andrew).github_id
    assert_equal users(:andrew), User.find_by_auth_hash(omniauth_config)
  end

  test '#assign_from_auth_hash updates the users github_id and access_token' do
    user                              = users(:andrew)
    omniauth_config                   = OmniAuth.config.mock_auth[:github]
    omniauth_config.uid               = 1
    omniauth_config.credentials.token = 'abcdefg'

    user.assign_from_auth_hash(omniauth_config)

    assert_equal 1, user.github_id
    assert_equal 'abcdefg', user.access_token
  end
end
