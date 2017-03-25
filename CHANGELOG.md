# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [v0.6.1] : 2017-3-25
### Changed
- Updated almost all of the gems used by this project.
- Plex changed their API and it broke this app. This should be fixed now.
- Changed maximum plex connection timeout to 1 second per attempt so we don't waste time.

## [v0.5.7] : 2016-7-8
### Changed
- Fixed `serverSetup.sh` thanks to @VuokkoVuorinnen's PR.
- Built a basic weather view, it's not pretty yet but it works.
- Layout of the sidebars/main content. It should collapse in a better fashion now.

### Removed
- HTML 5 shim for IE. We don't support IE (or rather IE doesn't support modern and widely accepted standards) so this is pointless. 
- Info/Status page. It had no use and I don't have a plan for it.

## [v0.5.6] : 2016-5-7
### Added
- Weather class and beginnings of tests
- Geolocation gem

## [v0.5.5] : 2016-4-27
### Added
- Added some logic to recreate deleted images folder while the server is running.

### Changed
- Updated install instructions in `README.md` after trying them out.


## [v0.5.4] : 2016-3-15
### Added
- Added some info to the "About" page
- Added more unit tests for `PlexService`


## [v0.5.3] : 2016-3-2
### Added
- Nil check on `service` for `get_plex_sessions` in the `PlexService` class


## [v0.5.2] : 2016-2-13
### Changed
- Started changing tests to use fabricators instead of fixtures. 
This will allow me have an easier time with the integration tests since the database won't be filled with garbage data.
- This changelog's formatting and stuff
- Rewrote unit tests for PlexService validation, the username and password unit tests weren't actually testing what they were supposed to test.


## [v0.5.1] : 2016-2-13
### Added
- VCR and real-world Plex server responses for Integration Tests
  - `service_test_config.yml` file and [example_service_test_config.yml](test/integration_test_config_files/example_service_test_config.yml) files were added to the test directory. 
  `service_test_config.yml` is in `.gitignore` so that my personal information does not make it into the repo.
- Added a fix for issue [#43](https://github.com/scytherswings/Plex-Board/issues/43) where assets were only being resolved with relative paths, making proxies not work. 
This change will set the assets to the localhost's FQDN. If DNS is not set up properly the server will probably crash.


## [v0.5.0] : 2016-2-8
### Added
- PhantomJS testing framework
  - Added one UI test to check for keywords on the homepage
- This changelog!

### Changed
- Updated to Ruby 2.3.0

