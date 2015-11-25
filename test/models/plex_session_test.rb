# require 'test_helper'
#
# class PlexSessionTest < ActiveSupport::TestCase
#
#
#   # teardown do
#   #   # puts
#   #   # puts 'Starting Teardown'
#   #   # ObjectSpace.each_object(File) do |f|
#   #   #   puts '%s: %d' % [f.path, f.fileno] unless f.closed?
#   #   # end
#   #   FileUtils.rm_rf('#{PlexSession.get('images_dir')}/.', secure: true)
#   #   # puts 'Teardown finished'
#   # end
#
#
#   test 'sessions should be valid' do
#     assert @session_one.valid?, 'Session_one was invalid'
#     assert @session_two.valid?, 'Session_two was invalid'
#     assert @session_three.valid?, 'Session_three was invalid'
#     # assert @session_four.valid?, 'Session_four was invalid'
#     # assert @session_five.valid?, 'Session_five was invalid'
#     # assert @session_six.valid?, 'Session_six was invalid'
#     assert @session_seven.valid?, 'Session_seven was invalid'
#   end
#
#   test 'user_name should be present' do
#     @session_one.user_name = nil
#     assert_not @session_one.valid?, 'PlexSession user_name should not be nil'
#     @session_one.user_name = ''
#     assert_not @session_one.valid?, 'PlexSession user_name should not be empty string'
#   end
#
#   test 'user_name should not be whitespace only' do
#     @session_one.user_name = '     '
#     assert_not @session_one.valid?, 'PlexSession with whitespace string user_name should not be valid'
#   end
#
#
#   test 'session should be unique' do
#     duplicate_session = @session_one.dup
#     @session_one.save
#     assert_not duplicate_session.valid?, 'Duplicate session should not be valid'
#   end
#
#   #Tests for Plex integration
#
#   test 'session should successfully retrieve image' do
#     assert @session_seven.delete_thumbnail, 'Deleting thumbnail failed'
#     assert_not File.file?(Rails.root.join 'test/test_images', (@session_seven.id.to_i.to_s + '.jpeg')),
#            'Image file should not be present'
#     assert_not_nil @session_seven.get_plex_object_img, 'Image file was not retrieved'
#     assert File.file?(Rails.root.join 'test/test_images', (@session_seven.id.to_i.to_s + '.jpeg')),
#            'Image file was not found'
#   end
#
#   test 'destroying a session will delete the associated image' do
#     assert_not_nil @session_seven.get_plex_object_img, 'Image file was not retrieved'
#     assert File.file?(Rails.root.join 'test/test_images', (@session_seven.id.to_i.to_s + '.jpeg')),
#            'Image file was not found'
#     assert @session_seven.destroy, 'Destroying the session failed'
#     assert_not File.file?(Rails.root.join 'test/test_images', (@session_seven.id.to_i.to_s + '.jpeg')),
#         'The image file was not deleted'
#   end
#
#
# end
