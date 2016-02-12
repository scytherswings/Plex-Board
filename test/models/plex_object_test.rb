require 'test_helper'

class PlexObjectTest < ActiveSupport::TestCase

  test 'plex_objects should be valid' do
    assert @plex_object_session_2.valid?
    assert @plex_object_session_1.valid?
    assert @plex_object_session_3.valid?
    assert @plex_object_recently_added_1.valid?
  end

  test 'plex_object media_title must not be blank' do
    @plex_object_session_1.media_title = nil
    assert_not @plex_object_session_1.valid?, 'media_title should not be allowed to be nil'
    @plex_object_session_1.media_title = ''
    assert_not @plex_object_session_1.valid?, 'media_title should not be allowed to be an empty string'
  end

  test 'user_name should not be allowed to be whitespace only' do
    @plex_object_session_1.media_title = '     '
    assert_not @plex_object_session_1.valid?, 'media_title should not be allowed to be a whitespace string'
  end

  test 'plex_object should successfully retrieve image' do
    # Temporary until I figure out why this directory doesn't get created in proper time.
    unless File.directory? Rails.root.join 'test/test_images'
      skip 'The test/test_images folder does not exist. This test will probably fail.'
    end
    assert @plex_object_session_1.delete_thumbnail, 'Deleting thumbnail failed'
    assert_not File.file?(Rails.root.join 'test/test_images', (@plex_object_session_1.id.to_s + '.jpeg')),
               'Image file should not be present'
    assert_not_nil @plex_object_session_1.get_img, 'Image file was not retrieved'
    assert File.file?(Rails.root.join 'test/test_images', (@plex_object_session_1.id.to_s + '.jpeg')),
           'Image file was not found'
  end

  test 'destroying a plex_object will delete the associated image' do
    # Temporary until I figure out why this directory doesn't get created in proper time.
    unless File.directory? Rails.root.join 'test/test_images'
      skip 'The test/test_images folder does not exist. This test will probably fail.'
    end
    assert_not_nil @plex_object_session_1.get_img, 'Image file was not retrieved'
    assert File.file?(Rails.root.join 'test/test_images', (@plex_object_session_1.id.to_s + '.jpeg')),
           'Image file was not found'
    assert @plex_object_session_1.destroy, 'Destroying the session failed'
    assert_not File.file?(Rails.root.join 'test/test_images', (@plex_object_session_1.id.to_s + '.jpeg')),
               'The image file was not deleted'
  end
end
