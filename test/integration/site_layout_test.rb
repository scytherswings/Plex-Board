require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  keywords = %w(Plex-Board Services Config Status About)

  # def teardown
  #   super
  #   Capybara.reset_sessions!
  #   Capybara.use_default_driver
  # end
  # Capybara::Screenshot.screenshot_and_save_page

  test 'check index for all expected links' do
    visit '/'
    keywords.each do |word|
      assert page.has_content?(word), "#{word} was missing from \"/\""
    end
    assert page.has_title?('Plex-Board'), '"Plex-Board" was not the title for "/"'
  end

  test 'hit index and check carousel-inner exists' do
    visit '/'
    assert page.has_selector?('#carousel-inner'), '#Carousel-inner was missing from page'
  end
end
