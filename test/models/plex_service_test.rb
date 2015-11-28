require 'test_helper'

class PlexServiceTest < ActiveSupport::TestCase


  #Tests for Plex integration


  test 'Plex_service_with_one_session should have a session' do
    assert_equal 1, @plex_service_with_one_session.plex_sessions.count, 'Plex_service_with_one_session number of sessions did not match 1'
  end

  test 'Plex_service_with_two_sessions should have two sessions' do
    assert_equal 2, @plex_service_with_two_sessions.plex_sessions.count, 'Plex_service_with_two_sessions number of sessions did not match 2'
  end

  test 'username must not be > 255 char' do
    @plex_service_one.username = 'x' * 256
    assert_not @plex_service_one.valid?, 'username should be <= 255 char'
  end

  test 'password must not be > 255' do
    @plex_service_one.password = 'x' * 256
    assert_not @plex_service_one.valid?, 'password should be <= 255 char'
  end

  test 'get_plex_token will get token if token is nil' do
    @plex_service_with_no_token.get_plex_token
    assert_requested(:post, 'https://user:pass@my.plexapp.com/users/sign_in.json')
    assert_equal TOKEN, @plex_service_with_no_token.token
  end

  test 'plex_api will not get token if token is present' do
    assert_equal TOKEN, @plex_service_with_one_session.token
    @plex_service_with_one_session.plex_api(:get, '/status/sessions')
    assert_not_requested(:post, 'https://user:pass@my.plexapp.com/users/sign_in.json')
  end

  test 'Service with no sessions will not change when plex has no sessions' do
    @plex_service_one.service.dns_name = 'plexnosessions'
    @plex_service_one.get_plex_sessions
    assert_requested(:get, 'https://plexnosessions:32400/status/sessions')
    assert_equal TOKEN, @plex_service_one.token
    assert_equal 0, @plex_service_one.plex_sessions.count
  end

  test 'Service with no sessions can get two new plex sessions' do
    @plex_service_with_two_sessions.plex_sessions.destroy_all
    assert_equal 0, @plex_service_with_two_sessions.plex_sessions.count
    assert_difference('@plex_service_with_two_sessions.plex_sessions.count', +2) do
      assert_not_nil @plex_service_with_two_sessions.get_plex_sessions, 'Getting plex sessions returned nil'
      assert_requested(:get, 'https://plex6:32400/status/sessions')
    end
  end

  test 'Service with a session can update the existing plex session' do
    skip('This needs to be redone')
    assert_equal 1, @plex_service_with_one_session.plex_sessions.count
    temp = @plex_service_with_one_session.plex_sessions.first.clone
    assert_not_nil @plex_service_with_one_session.token
    assert_not_nil @plex_service_with_one_session.plex_sessions.first.plex_service_token
    assert @plex_service_with_one_session.service.update(:dns_name => 'plex5updated')
    assert_not_nil @plex_service_with_one_session.get_plex_sessions
    assert_requested(:get, 'https://plex5updated:32400/status/sessions')
    assert_equal 1, @plex_service_with_one_session.plex_sessions.count, 'PlexSession number should not change'
    assert_equal temp.id, @plex_service_with_one_session.plex_sessions.first.id, 'PlexSession ID should not change when we are updating'
    #ho lee shit. This fucking line right here... damn SQL.
    # http://stackoverflow.com/questions/14598604/rails-factory-girl-rolling-back-in-the-middle-of-a-spec-and-transactions
    @plex_service_with_one_session.reload
    assert_not_equal @plex_service_with_one_session.plex_sessions.first.progress, temp.progress
  end


  test 'PlexSession will be removed if Plex has no sessions' do
    assert_equal 1, @plex_service_with_one_session.plex_sessions.count
    @plex_service_with_one_session.service.update(dns_name: 'plexnosessions')
    assert_difference('@plex_service_with_one_session.plex_sessions.count', -1) do
      @plex_service_with_one_session.get_plex_sessions
    end
    assert_requested(:get, 'https://plexnosessions:32400/status/sessions')
  end


  test 'Expired sessions will be removed' do
    assert_equal 2, @plex_service_with_two_sessions.plex_sessions.count
    @plex_service_with_two_sessions.service.update(dns_name: 'plex5')
    assert_difference('@plex_service_with_two_sessions.plex_sessions.count', -1) do
      @plex_service_with_two_sessions.get_plex_sessions
      assert_requested(:get, 'https://plex5:32400/status/sessions')
    end
  end

  test 'Calling get_plex_sessions will only add session once' do
    assert_equal 1, @plex_service_with_one_session.plex_sessions.count
    assert @plex_service_with_one_session.plex_sessions.destroy_all
    assert_difference('@plex_service_with_one_session.plex_sessions.count', +1) do
      @plex_service_with_one_session.get_plex_sessions
      @plex_service_with_one_session.get_plex_sessions
      @plex_service_with_one_session.get_plex_sessions
    end
    assert_requested(:get, 'https://plex5:32400/status/sessions', times: 3)
  end

  # test 'offline service will skip api calls' do
  #   skip('Not finished')
  # end

end