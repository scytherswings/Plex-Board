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

  test 'session will correctly identify stream_type Stream' do
     assert_equal('Stream',PlexSession.determine_stream_type('copy'), 'copy videoDecision was not correctly translated to Stream')
     assert_equal('Stream',PlexSession.determine_stream_type('COPY'), 'COPY videoDecision was not correctly translated to Stream')
  end

  test 'session will correctly identify stream_type Transcode' do
    assert_equal('Transcode',PlexSession.determine_stream_type('transcode'), 'transcode videoDecision was not correctly translated to Transcode')
    assert_equal('Transcode',PlexSession.determine_stream_type('TRANSCODE'), 'TRANSCODE videoDecision was not correctly translated to Transcode')
  end

  test 'session will correctly ignore stream_type nil or empty' do
    PlexSession.determine_stream_type('')
    PlexSession.determine_stream_type(nil)
  end

  #Tests for Plex integration






end
