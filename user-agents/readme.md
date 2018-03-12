# Separating machine, robot and unknown user agents

There is a list of robot user-agents at [Counter-Robots](https://raw.githubusercontent.com/atmire/COUNTER-Robots/master/COUNTER_Robots_list.json).
It's not just a list of robot user-agents. It includes some items that are robots, some items that are
programatic default strings (like names of programming languages, libraries or Unix tools) and some things that
are browser add-ons (such a download managers).  It also seems to contain some older browser user-agents or it's not obvious what some user-agent patterns represent. ¯\_(ツ)_/¯

We need to differentiate between machine access, robot access (which is a special kind of machine access)
and everything else which we ignore or consider human access.

The script *./robots_import.rb* will get updates from that big glob of random robot-y stuff list and allow a user to
interactively classify items that have not been classified yet and write the (updated) results to
*lists/classified-list.yaml*.

You can look at and edit the YAML by hand in a text editor and move items
to different sections in order to reclassify things.  Watch out for leading spaces, etc since they
may sometimes be significant in YAML.

The good side of YAML is that it's easier for humans
to read than JSON and can also be more compact than formatted JSON strings.  It's very easy to
do programatic conversion from YAML to JSON (or back) in most modern scripting languages like Python,
Ruby (and probably even JavaScript with the aid of some libraries).

*./generate_lists.rb* will output text files in the *lists* directory of just the regular expression patterns for each type of
user-agent (separated by newlines) which is all we really need for log processing.  The first
line of the text file has a commment (starting with #) telling people to regenerate them and not edit them directly and would be ignored by a program.

##Ruby Environment

Ruby is probably already installed in many modern OS environments. If not, it is likely available in your
package manager or however you install software on your operating system.

You might need to install the bundler gem ("gem install bundler") and do "bundle install" to satisfy/install
the few gem dependencies here before running one of these scripts.
