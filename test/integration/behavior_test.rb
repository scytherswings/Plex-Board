# require 'test_helper'
#
# class BehaviorTest < ActionDispatch::IntegrationTest
#   # These tests will ensure that the UI functions as designed.
#
#   def teardown
#     super
#     Capybara.reset_sessions!
#     Capybara.use_default_driver
#   end
#
#   # # Setup: At least one service in the online state.
#   # # Steps:
#   # # Action 1: The service will be taken offline
#   # # Result 1: The UI button will be updated by js to reflect the change
#   # test 'A service taken offline will have its button updated to reflect the change' do
#   #   skip "Unfinished test"
#   #   visit '/'
#   # end
#   #
#   # # Setup: At least one service in the offline state.
#   # # Steps:
#   # # Action 1: The service will be put back online
#   # # Result 1: The UI button will be updated by js to reflect the change
#   # test 'A newly onlined service will have its button updated to reflect the change' do
#   #   skip "Unfinished test"
#   #   visit '/'
#   # end
#   #
#   # # Setup: A Plex service in the online state.
#   # # Steps:
#   # # Action 1: A new session will started
#   # # Result 1: The UI will have the new session added to the carousel
#   # test 'A newly started Plex Session will show in the carousel' do
#   #   skip "Unfinished test"
#   #   visit '/'
#   # end
#   #
#   # # Setup: A Plex service in the online state. A session is in progress.
#   # # Steps:
#   # # Action 1: The session will be stopped
#   # # Result 1: The UI will have the session removed from the carousel
#   # test 'A stoppped Plex Session will be removed from the carousel' do
#   #   skip "Unfinished test"
#   #   visit '/'
#   # end
#   #
#   # # Setup: A Plex service in the online state.
#   # # Steps:
#   # # Action 1: Add content to the Plex server
#   # # Result 1: The UI will have the newly added content added to the carousel
#   # test 'A newly added Plex Media Item will show in the carousel' do
#   #   skip "Unfinished test"
#   #   visit '/'
#   # end
#
#
#   # # Setup: A Plex service in the online state. PS has a bad token.
#   # # Steps:
#   # # Action 1: update_plex_data from Plex server
#   # # Result 1: The server returns a 401. The UI displays an error message.
#   # test 'An expired token will raise an error in the UI' do
#   #
#   # end
#
#
# end
