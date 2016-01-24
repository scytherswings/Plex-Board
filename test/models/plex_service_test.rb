require 'test_helper'

class PlexServiceTest < ActiveSupport::TestCase


  test 'plex services should be valid' do
    assert @plex_service_one.valid?
    assert_not @plex_service_with_no_token.valid?, 'Plex service with no token should not be valid'
    assert @plex_service_with_one_session.valid?
    assert @plex_service_with_two_sessions.valid?
  end

  test 'Plex_service_with_one_session should have a session' do
    assert_equal 1, @plex_service_with_one_session.plex_sessions.count, 'Plex_service_with_one_session number of sessions did not match 1'
  end

  test 'Plex_service_with_two_sessions should have two sessions' do
    assert_equal 2, @plex_service_with_two_sessions.plex_sessions.count, 'Plex_service_with_two_sessions number of sessions did not match 2'
  end

  # test 'username must not be > 255 char' do
  #   @plex_service_with_no_token.username = 'x' * 256
  #   assert_not @plex_service_with_no_token.valid?, 'username should be <= 255 char'
  # end
  #
  # test 'password must not be > 255' do
  #   # @plex_service_with_no_token.password = 'x' * 256
  #   assert @plex_service_with_no_token.valid?, 'password should be <= 255 char'
  # end

  test 'username must not be > 255 characters' do
    assert_raises ActiveRecord::RecordInvalid do
      PlexService.create!(username: ('x' * 256), password: 'x')
    end
  end

  test 'password must not be > 255 characters' do
    assert_raises ActiveRecord::RecordInvalid do
      PlexService.create!(username: 'x', password: ('x' * 256))
    end
  end

  test 'username must not be an empty string' do
    assert_raises ActiveRecord::RecordInvalid do
      PlexService.create!(username: '', password: 'x')
    end
  end

  test 'username must not be empty spaces' do
    assert_raises ActiveRecord::RecordInvalid do
      PlexService.create!(username: '    ', password: 'x')
    end
  end
  
  test 'password must not be an empty string' do
    assert_raises ActiveRecord::RecordInvalid do
      PlexService.create!(username: 'x', password: '')
    end
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
    @plex_service_with_two_sessions.service.reload
    assert_difference('@plex_service_with_two_sessions.plex_sessions.count', +2) do
      assert_not_nil @plex_service_with_two_sessions.get_plex_sessions, 'Getting plex sessions returned nil'
      assert_requested(:get, 'https://plex6:32400/status/sessions')
    end
  end

  test 'Service with a session can update the existing plex session' do
    @plex_service_with_one_session.plex_sessions.reload
    assert_equal 1, @plex_service_with_one_session.plex_sessions.count
    temp = @plex_service_with_one_session.plex_sessions.first.clone
    assert_not_nil @plex_service_with_one_session.token
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
    @plex_service_with_one_session.get_plex_sessions
    assert_requested(:get, 'https://plexnosessions:32400/status/sessions')
    assert_equal 0, @plex_service_with_one_session.plex_sessions.count
  end


  test 'Expired sessions will be removed' do
    assert_equal 2, @plex_service_with_two_sessions.plex_sessions.count
    @plex_service_with_two_sessions.service.update(dns_name: 'plex5')
    @plex_service_with_two_sessions.get_plex_sessions
    assert_requested(:get, 'https://plex5:32400/status/sessions')
    assert_equal 1, @plex_service_with_two_sessions.plex_sessions.count
  end

  test 'Calling get_plex_sessions will only add session once' do
    assert_equal 1, @plex_service_with_one_session.plex_sessions.count
    assert @plex_service_with_one_session.plex_sessions.destroy_all
    assert_difference('@plex_service_with_one_session.plex_sessions.count', +1) do
      3.times {@plex_service_with_one_session.get_plex_sessions}
    end
    assert_requested(:get, 'https://plex5:32400/status/sessions', times: 3)
  end

  test 'offline service will skip api calls' do
    @plex_service_with_one_session.service.online_status = false
    @plex_service_with_one_session.plex_sessions.destroy_all
    @plex_service_with_one_session.get_plex_sessions
    assert_requested(:get, 'https://plex5:32400/status/sessions', times: 0)
    assert_equal 0, @plex_service_with_one_session.plex_sessions.count
  end

  test 'get_plex_recently_added can get new RA movie when no RAs exist' do
    @plex_service_with_one_recently_added.service.update(dns_name: 'plex7_movie')
    @plex_service_with_one_recently_added.plex_recently_addeds.destroy_all
    @plex_service_with_one_recently_added.get_plex_recently_added
    assert_requested(:get, 'https://plex7_movie:32400/library/recentlyAdded')
    assert_equal 1, @plex_service_with_one_recently_added.plex_recently_addeds.count, 'PRA count was not 1'
  end

  test 'get_plex_recently_added can get new RA tv_show when no RAs exist' do
    @plex_service_with_one_recently_added.service.update(dns_name: 'plex7_tv_show')
    @plex_service_with_one_recently_added.plex_recently_addeds.destroy_all
    @plex_service_with_one_recently_added.get_plex_recently_added
    assert_requested(:get, 'https://plex7_tv_show:32400/library/recentlyAdded')
    assert_equal 1, @plex_service_with_one_recently_added.plex_recently_addeds.count, 'PRA count was not 1'
  end

  test 'get_plex_recently_added can get many new RAs when no RAs exist' do
    @plex_service_with_one_recently_added.service.update(dns_name: 'plex7_all')
    @plex_service_with_one_recently_added.plex_recently_addeds.destroy_all
    @plex_service_with_one_recently_added.get_plex_recently_added
    assert_requested(:get, 'https://plex7_all:32400/library/recentlyAdded', times: 1)
    assert_equal 50, @plex_service_with_one_recently_added.plex_recently_addeds.count, 'PRA count was not 50'
  end

  test 'get_plex_recently_added can remove RAs when given nothing' do
    @plex_service_with_one_recently_added.service.update(dns_name: 'plex7_none')
    @plex_service_with_one_recently_added.get_plex_recently_added
    assert_requested(:get, 'https://plex7_none:32400/library/recentlyAdded')
    assert_equal 0, @plex_service_with_one_recently_added.plex_recently_addeds.count, 'PRA count was not 0'
  end

  test 'get_plex_recently_added will not add duplicate pras' do
    @plex_service_with_one_recently_added.service.update(dns_name: 'plex7_all')
    @plex_service_with_one_recently_added.plex_recently_addeds.destroy_all
    3.times {@plex_service_with_one_recently_added.get_plex_recently_added}
    assert_requested(:get, 'https://plex7_all:32400/library/recentlyAdded', times: 3)
    assert_equal 50, @plex_service_with_one_recently_added.plex_recently_addeds.count, 'PRA count was not 50'
  end


  test 'get_plex_token will only hit the api once if given a 404' do
    test = PlexService.new
    test.username = '404user'
    test.password = 'pass'
    3.times {test.save}
    assert_not test.valid?
    assert_requested(:post, 'https://404user:pass@my.plexapp.com/users/sign_in.json', times: 1)
  end

  test 'get_plex_token will only hit the api once if given a 403' do
    test = PlexService.new
    test.username = 'baduser'
    test.password = 'pass'
    3.times {test.save}
    assert_not test.valid?
    assert_requested(:post, 'https://baduser:pass@my.plexapp.com/users/sign_in.json', times: 1)
  end

  test 'get_plex_token will only hit the api once if given a 401' do
    test = PlexService.new
    test.username = 'user'
    test.password = 'badpass'
    3.times {test.save}
    assert_not test.valid?
    assert_requested(:post, 'https://user:badpass@my.plexapp.com/users/sign_in.json', times: 1)
  end

  test 'a new valid PlexService will have a token after saving' do
    test = PlexService.new
    test.username = 'user'
    test.password = 'pass'
    test.save
    assert_requested(:post, 'https://user:pass@my.plexapp.com/users/sign_in.json', times: 1)
    assert test.valid?
  end

  test 'a successful auth to plex.tv will delete passwords from the database' do
    test = PlexService.new
    test.username = 'user'
    test.password = 'pass'
    test.save
    assert_requested(:post, 'https://user:pass@my.plexapp.com/users/sign_in.json', times: 1)
    assert test.valid?
    assert test.username.nil?
    assert test.password.nil?
  end
end