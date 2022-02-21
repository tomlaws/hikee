13/10/21
added features:
- collapsable warning
- show floating tooltip when near the goal
- link to google map to provide ways to reach start of the trail
- update of profile page, show trophies
- records system

27/10/21
- compass
- display walked path
- background tracking, with notification
- show speed and estimated finish time

10/11/21
1. added create trail feature (top-right button of the trails page)
    - putting markers on map
    - input details to publish the trail
2. updated trails page
    - added classification as listed in (https://zh.wikipedia.org/wiki/%E9%A6%99%E6%B8%AF%E9%83%8A%E9%81%8A%E8%B7%AF%E5%BE%91)
        - Long-distance trail
        - Country trail
        - Family walk
        - Tree walk
        - Nature trail
        - Geo route
        - Recommended route
3. updated trail page
    - show marquee when the trail name is too long
    - turn into expandable description when description is too long
    - enlarge image by tapping it, and can zoom in/out
4. updated topic(s) page
    - added user profile pic in the topic list
    - added "pull to refresh" feature
    - added categories selection (clicking the title in the top left corner)
    - added image upload feature (supports multiple images) for creating new topic
    - show carousel as part of the content and enlarge the image by clicking it (lightbox)

26/11/21
1. use Topographic Map API instead of Google Maps
    - more up-to-date
    - faster rendering in the app compared to Google Maps
    - has contour lines
2. updated elements on the map
    - gradient path (easier to identity the start & end, especially for some paths that start & end at the same location)
    - added message feature (attach a message to a location)
4. updated search trail filter
    - select region(s)
    - filter trails by duration
    - filter trails by length
5. updated records page (need login, ac abcd@gmail.com / pw 654321)
    - added search feature
        - by date, regions, length, duration


12/1/21
1. WGS84 to HK80 and HK80 back to WGS84
    http://www.geodetic.gov.hk/transform/v2/?inSys=wgsgeog&outSys=hkgrid&lat=22.2&long=114.2
2. https://geodata.gov.hk/gs/api/v1.0.0/searchNearby?x=835665&y=817198



FEB
1.  add profile page (tapping other user's avatar)
    - display trail history (can be disabled in privacy setting, opt-in approach)
    - show original trail and referenced trail for each record (for comparison / completion probably)
2. allow custom map provider in preferences settings (with attribution on the map face accordingly)
3. nearby facilities
    - show distance between facility and current location in the list
    - allow putting a pin of the facility on the map view
    - view estimated arrival time to the facility
4. add recording mode (determine region by the recorded path as well)
    - able to rename record and save
    - may able to publish as a new trail in the future (feature)

TODO:
emergency update
check if the user location is in hong kong
date filter
offline mode
ui when location permission is rejected
turn on/off weather report, custom weather refresh interval, for battery saving