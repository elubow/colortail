# ColorTail #

What does ColorTail do for me?

ColorTail provides a cool way for you to configure how logfiles (or any other files for that matter) look when you tail them.

## Installation ##

### Install the gem ##
    gem install colortail

## Using ColorTail ##

By default, ColorTail does absolutely nothing other than just tail a file normally (similar to the trust old unix tool 'tail -f').  But what good what writing a gem be if it just mimiced existing functionality.

## Conifguring ColorTail ##

Configuring ColorTail is easy.  In your home directory, create a file .colortailrc.  This file will contain a group of ruby arrays similar to the ones laid out in the example config **examples/colortail.rb**.  These arrays are called groups.  Any group can be loaded via the command line using the **-g** switch (more on this below).

The standard configuration file is **.colortailrc**.  It needs to be in the format of a Ruby hash.

## Usage ##

Using ColorTail is similar to using tail. The main assumption is that you will always be _indefinitely_ tail'ing a file. Currently ColorTail only allows for tailing 1 file.

#### Tailing with groups

The command below will tail the **/var/log/messages** file using the syslog group. The example config **examples/colortail.rb** shows a _syslog_ grouping that is used in command below:

   # colortail -g syslog /var/log/messages

## Author ##

Eric Lubow &lt;eric at lubow dot org&gt;

  * Web: [http://eric.lubow.org/](http://eric.lubow.org)
  * Twitter: [elubow](http://twitter.com/elubow)

## Note on Patches/Pull Requests
 
  * Fork the project.
  * Make your feature addition or bug fix.
  * Add tests for it. This is important so I don't break it in a
    future version unintentionally.
  * Commit, do not mess with rakefile, version, or history.
    (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
  * Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2010 Eric Lubow. See LICENSE for details.
