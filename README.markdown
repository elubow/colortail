# ColorTail #

What does ColorTail do for me?

ColorTail provides a cool way for you to configure how logfiles (or any other files for that matter) look when you tail them.

## Installation ##

### Install the gem ##
    gem install colortail

## Using ColorTail ##

By default, ColorTail does absolutely nothing other than just tail a file normally (similar to the trust old unix tool 'tail -f').  But what good what writing a gem be if it just mimiced existing functionality.

## Conifguring ColorTail ##

Configuring ColorTail is easy.  In your home directory, create a file .colortailrc.  This file will contain a group of ruby arrays similar to the ones laid out in the [example config](http://codaset.com/elubow/colortail/examples/colortail.rb).  These arrays are called groups.  Any group can be loaded via the command line using the **-g** switch (more on this below).

## Usage ##

Using ColorTail is similar to using tail. The main assumption is that you will always be _indefinitely_ tail'ing a file.

#### Tailing with groups

The command below will tail the **/var/log/messages** file using the syslog group. The [example config](http://codaset.com/elubow/colortail/examples/colortail.rb) shows a _syslog_ grouping that is used in command below:

   # colortail -g syslog /var/log/messages

## Author ##

Eric Lubow &lt;eric at lubow dot org&gt;
* Web: [http://eric.lubow.org/](http://eric.lubow.org)
* Twitter: [elubow](http://twitter.com/elubow)
