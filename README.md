# Pre-work - iTipsCalculator

iTipsCalculator is a tip calculator application for iOS.

Submitted by: James Zhou

Time spent: 6.5 hours spent in total

## User Stories

The following **required** functionality is complete:

* [x] User can enter a bill amount, choose a tip percentage, and see the tip and total values. (SWIPE LEFT AND RIGHT TO CHANGE TIP PERCENTAGE)
* [x] Settings page to change the default tip percentage.

The following **optional** features are implemented:
* [ ] UI animations
* [x] Remembering the bill amount across app restarts (if <10mins)
* [x] Using locale-specific currency and currency thousands separators.
* [x] Making sure the keyboard is always visible and the bill amount is always the first responder. This way the user doesn't have to tap anywhere to use this app. Just launch the app and start typing.

The following **additional** features are implemented:

- [x] Use SnapKit (from Cocoapods) to implement AutoLayout. Tested on iPhone 5, 6 and 6plus screen sizes.
- [x] Swipe left and right to change tip percentage between minimum percentage and maximum percentage
- [x] Configure default, minimum and maximum percentage in the settings page
- [x] Prevent user from typing in invalid numbers (like "32.." or "1.2.")
- [x] Double tap total amount to round to the nearest integer
- [x] Disable double tap feature in the Settings page
- [x] Support 3D Touch Quick Actions to quickly tip 10%, 15% or 20%

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='https://github.com/zihanzzz/TipCalculator/blob/master/gif/iTipsCalculator.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />
<img src='https://github.com/zihanzzz/TipCalculator/blob/master/gif/3DTouch.gif' title='3D Touch' width='' alt='3D Touch' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

One of the most challenging part was to manipulate the UI components on the main ViewController. SnapKit was really helpful, but I had to think very carefully of where each UI components land on the screen. I know that in an iOS team, working with Storyboards is very painful because Storyboard files are extremely hard to merge and error-prone. I programmatically added the UI components, which I found a lot easier to deal with.

Another thing that I needed to think carefully before implementing is the life cycle of the view controller. Instance variables need to be initialized properly when the view controller is being loaded.

I also have to use breakpoints to debug. Xcode is very friendly in terms of setting breakpoints to debug, if you compare it to Eclipse. When I was implementing 3D touch Quick Actions, I needed to see which function was invoked and more importantly, the order of the invocation.

## License

    Copyright 2016 James Zhou

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.