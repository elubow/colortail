# ColorTail #

What does ColorTail do for me?

ColorTail provides a cool way for you to configure how logfiles (or any other files for that matter) look when you tail them.

## Installation ##

### Install the gem ##
    gem install colortail

## Using ColorTail ##

By default, ColorTail does absolutely nothing other than just tail a file normally (similar to the trust old unix tool 'tail -f').  But what good what writing a gem be if it just mimiced existing functionality.

## Conifguring ColorTail ##

Configuring ColorTail is easy.  In your home directory, create a file .colortailrc.  This file will contain a group of ruby arrays similar to the ones laid out in the example config [examples/colortail.rb](https://github.com/elubow/colortail/blob/master/examples/colortail.rb).  These arrays are called groups.  Any group can be loaded via the command line using the **-g** switch (more on this below).

The standard configuration file is **.colortailrc**.  It needs to be in the format of a Ruby hash.

The full list of choices for colors and combinations are listed below.

#### Colors ####

 * none - Yes you can have no color.  This means display normally.
 * black
 * red
 * green
 * yellow
 * blue
 * magenta - (purple-ish)
 * cyan
 * light gray

#### Attributes ####

 * bright
 * dim
 * underscore
 * blink
 * reverse
 * hidden - simply don't show the text

#### Additional Colors ####

To get the additional colorset listed below, use the **bright** attribute.

 * dark gray (bright black)
 * light blue (bright blue)
 * light green (bright green)
 * light cyan (bright cyan)
 * light red (bright red)
 * light purple (bright purle)
 * yellow (bright brown)
 * white (bright light gray)

### Configuration Example ###

The example given in the configuration file is good for tailing a syslog file that has lines that are naemd with their syslog level. There are a lot of potential uses.  Check the wiki page of [example groupings](http://www.codaset.com/elubow/colortail/wiki/example-groupings) to see how others are using ColorTail.

## Usage ##

Using ColorTail is similar to using tail. The main assumption is that you will always be _indefinitely_ tail'ing a file.

#### Tailing with groups

The command below will tail the **/var/log/messages** file using the syslog group. The example config [examples/colortail.rb](http://www.codaset.com/elubow/colortail/source/master/blob/examples/colortail.rb) shows a _syslog_ grouping that is used in command below (the below 2 commands are equivilent):

   # colortail -g syslog /var/log/messages
   # cat /var/log/messages | colortail -g syslog

#### Tailing multiple files

To tail multiple files can be confusing, especially when you don't know which file you are seeing. Use the **-F** option to show the filenames at the beginning of each colored line.

   # colortail -F -g syslog /var/log/messages /var/log/secure.log

#### Tailing multiple files using different color groups

You can also tail multiple files using different color groups. Currently, the separater is *#*. If no grouping is specified with the file or the grouping specified doesn't exist, colortail will default to the one specied on the command line.

   # colortail /var/log/messages#syslog /var/log/secure.log#otherlog
   # colortail -g syslog /var/log/messags#nosuchgroup /var/log/secure.log#secure

## Caveats and Intended Behaviors ##

ColorTail intentionally does not die when a file specified on the command line doesn't exist.

## Additional Information ##

  * Homepage: [https://github.com/elubow/colortail](https://github.com/elubow/colortail)

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
