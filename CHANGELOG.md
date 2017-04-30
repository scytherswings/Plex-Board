# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [v0.12.1] : 2017-4-27
### Changed
- Added validations to plex_sessions which make sure that when we try to do math
there will actually be numbers to do the math on.
  - If you have any issues try running `rake db:migrate:redo` from the root folder
  of the application.
- Fixed the ordering of Plex Recently Added

## [v0.12.0] : 2017-4-15
### Changed
- __!!!IMPORTANT!!!__ \
  The `server_config.yml` file has changed formats. You will need to delete the one you have
  in order to consume this update!
  - The new format makes more sense and has better descriptions along with examples.
- [update.sh](update.sh) was changed so you'll need to do a `git pull` before you run it. \
   This is because `update.sh` cannot manipulate itself while it is running. I will figure out something more 
   graceful in the future.
   - If you have issues you might need to do a `git reset --hard` to get your local changes back to an update-able state.
- Overhauled the overhauled scripts again. They now provide better support for windows.
  - Added `set -e` to all of the scripts so they will stop if any errors occur.

### Added
- Docker support is here!
  - You can find the container [here](https://hub.docker.com/r/scytherswings/plex-board/).
  - Docker is the preferred deployment strategy on Windows systems as it resolves all of the 
  cross-platform issues.
  - See the install guide [here](https://github.com/scytherswings/Plex-Board/wiki/Plex-Board-Docker-Installation-Guide).
  

## [v0.11.0] : 2017-4-6
### Changed
- Major overhaul to the `bash` scripts.
  - `runServer.sh` was renamed to [startServer.sh](startServer.sh)
  - All scripts will try to run in the directory in which they are located so they should
  be safe to call from anywhere.
- The server now defaults to running as a daemon! This means you don't have to leave 
your shell open anymore!

### Added
- Operating system detection
  - It is very basic so please file a bug if you see `setupServer.sh` incorrectly identifying your OS!
 

## [v0.10.0] : 2017-4-6
### Added
- `Dockerfile`!!!
  - This is great because it helps me test that the setup scripts work correctly.

## [v0.9.1] : 2017-4-5
### Fixed
- [Issue #69 Plex Recently Added was not updating as expected](https://github.com/scytherswings/Plex-Board/issues/69)

## [v0.9.0] : 2017-4-1
### Added
- Plex transcodes/streams counter in navbar.
    - Transcodes are counted separately from streams, I can change this if it's confusing.
### Changed
- Rearranged some controllers to reduce duplicated code
- Created helper method to generate a link for a plex service's streams/transcodes
    - Currently goes to the service itself.
- Commented out some unused dependencies sine there are no UI tests currently.

## [v0.8.0] : 2017-3-29
### Changed
- Moved endpoint for SSE stream from `services/notifications` to a new controller at `/notifications`
I wanted to put this behind a version bump in case anything breaks. Tests still pass (though there are no
UI tests currently)
- Only running tests on Ruby 2.3.3
### Removed
- Removed the `rm db/*.sqlite3` from the `serverSetup.sh` script because it would nuke a user's DB if they
run it after setting everything up which would suck.

## [v0.7.2] : 2017-3-26
### Changed
- Fixed broken service online status check. It was showing services as online that
  rejected the connection attempt. A test covers this properly now at the cost of a
  dependency on `redis` (for ease of install in Travis-CI). If you're going to run the tests
  locally then you'll need to install redis/something running on `6379`, or disable that test.
- Upgrade to Ruby `2.3.3`
    - If you're running ruby `2.3.0` you can upgrade your ruby by doing
    `rvm upgrade 2.3.0 2.3.3`

## [v0.7.1] : 2017-3-26
### Changed
- Increased database threadpool so puma doesn't run out 
http://stackoverflow.com/questions/12045495/activerecordconnectiontimeouterror-happening-sporadically

## [v0.7.0] : 2017-3-25
### Changed
- All online statuses are now held in cache. This makes SQLite3 much more happy.
- SSE has been overhauled to be less chatty. All updates are sent up to the page over SSE.
- The app should run faster now that the controller isn't blocked on checking 
  each service's status.
  
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

