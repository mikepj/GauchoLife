# Gaucho Life

Years ago, I had a SPARC workstation running SunOS that used Conway's Game of Life as the screensaver.  I loved watching it, and it's one of the biggest things I've missed about using that workstation and OS.  In 2018, I decided to write a screensaver for macOS that simulated the Game of Life.  I've used it for the past couple of years on my own Macs, but never released it publicly.  When I learned that Dr. Conway passed away earlier this week, on April 11, 2020, I decided to release this screensaver to the general public as a tribute.  

![Gaucho Life Screenshot](/Resources/screenshot-1.0.png)

I decided on a BSD license for it, so go ahead and use the code in other projects as long as you maintain the copyright notice and attribution.  It's written in Swift with just a single view controller in Obj-C, so the code is a reasonable guide for writing a modern screensaver.  Any imperfections are solely a result of this being the first screensaver I've ever put together.

I'm not planning to add any features, so if you're looking for something new, feel free to submit a PR.  Bug reports, of course, are always welcome via the Issues tab above.

## Download

https://download.gauchosoft.com/gaucholife/GauchoLife-1.0.0.zip

## Installation

To install, just download the latest release at the link above and double-click on the .saver file.  

In macOS 10.15 Catalina, there is a bug where if you install with System Preferences already open to the Screensaver configuration page, it won't be added to the list until after you Quit and reopen the System Preferences.
