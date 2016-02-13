# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [0.5.1] - 2016-2-13
### Added
- VCR and real-world Plex server responses for Integration Tests
  - service_test_config.yml file and example_service_test_config.yml files were added to the test directory. 
  service_test_config.yml is in .gitignore so that my personal information does not make it into the repo.
- Added a fix for issue #43 where assets were only being resolved with relative paths, making proxies not work. 
This change will set the assets to the localhost's FQDN. If DNS is not set up properly the server will probably crash.

## [0.5.0] - 2016-2-8
### Added
- PhantomJS testing framework
  - Added one UI test to check for keywords on the homepage
- This changelog!
### Changed
- Updated to Ruby 2.3.0