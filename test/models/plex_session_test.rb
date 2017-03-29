require 'test_helper'

class PlexSessionTest < ActiveSupport::TestCase

  test 'sessions should be valid' do
    assert @plex_service_w1sess_session_1.valid?, 'Session_one was invalid'
    assert @plex_service_w2sess_session_1.valid?, 'Session_two was invalid'
    assert @plex_service_w2sess_session_2.valid?, 'Session_three was invalid'
  end

  test 'plex_user_name should be present' do
    @plex_service_w1sess_session_1.plex_user_name = nil
    assert_not @plex_service_w1sess_session_1.valid?, 'plex_user_name should not be nil'
    @plex_service_w1sess_session_1.plex_user_name = ''
    assert_not @plex_service_w1sess_session_1.valid?, 'plex_user_name should not be empty string'
  end

  test 'user_name should not be allowed to be whitespace only' do
    @plex_service_w1sess_session_1.plex_user_name = '     '
    assert_not @plex_service_w1sess_session_1.valid?, 'plex_user_name should not be valid with whitespace string'
  end


  test 'session should be unique' do
    duplicate_session = @plex_service_w1sess_session_1.dup
    @plex_service_w1sess_session_1.save
    assert_not duplicate_session.valid?, 'Duplicate session should not be valid'
  end

  # test 'session will correctly identify stream type' do
  #     @plex.plex_sessions.destroy_all
  #     assert_equal 0, @plex_service_with_two_sessions.plex_sessions.count
  #     @plex_service_with_two_sessions.service.reload
  #     assert_equal('Transcode' ,@plex_service_with_two_sessions.session,'sum ting wong')
  #     assert_difference('@plex_service_with_two_sessions.plex_sessions.count', +2) do
  #       assert_not_nil @plex_service_with_two_sessions.get_plex_sessions, 'Getting plex sessions returned nil'
  #       assert_requested(:get, 'https://plex6:32400/status/sessions')
  #     end
  #   @plex_service_with_two_sessions.plex_sessions.destroy_all
  #   assert_equal('Transcode' ,.stream_type,'sum ting wong')
  #   assert_equal('Stream', @plex_service_w2sess_session_2.stream_type, 'fuku')
  # end

  #Tests for Plex integration






end
