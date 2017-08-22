# == Schema Information
#
# Table name: plex_objects
#
#  id                      :integer          not null, primary key
#  image                   :string
#  thumb_url               :string           not null
#  description             :text
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  plex_object_flavor_id   :integer
#  plex_object_flavor_type :string
#  media_title             :string           not null
#

require 'test_helper'

class PlexObjectTest < ActiveSupport::TestCase

  test 'plex_objects should be valid' do
    assert @plex_object_session_2.valid?
    assert @plex_object_session_1.valid?
    assert @plex_object_session_3.valid?
    assert @plex_object_recently_added_1.valid?
  end

  # test 'plex_object with no plex_session should not be valid' do
  #   skip('This test needs more thought')
  #   @plex_object_session_1.plex_object_flavor = nil
  #   assert_not @plex_object_session_1.valid?, 'Plex object should not be valid if there is no parent plex session'
  # end

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

  # test 'destroying a plex_object with a nil image will be successful' do
  #   ps = Fabricate(:plex_service)
  #   # ps.plex_recently_added.plex_object.image = nil
  #
  #   # assert(ps.plex_recently_added.destroy, 'The PlexObject was not destroyed')
  # end
end
