require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  keywords = %w(Plex-Board Services Config Status About)
  setup do
    Capybara.current_driver = Capybara.javascript_driver # :selenium by default

  end

  def teardown
    super
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end


  test 'check index for all expected links' do
    # keywords = %w(Plex-Board Services Config Status About)
    visit '/'
    keywords.each do |word|
      assert page.has_content?(word), "#{word} was missing from \"/\""
    end
    assert page.has_title?('Plex-Board'), '"Plex-Board" was not the title for "/"'
  end

  # test 'hit index and check for carousel item' do
  #   visit '/'
  #   assert page.has_selector?('carousel'), 'Carousel was missing from page'
  # end
end
