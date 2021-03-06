#!/usr/bin/env  sh
# GNU bash, version 4.3.33(1)-release (i686-pc-cygwin)
# dash 0.5.7-4+b1



# Lines like this one, with a preceeding number sign are commented-out.



# HEREDOC aka Here document
#   inline comments, or aborting a script from this point on.
: <<'HERE_DOCUMENT'
  this text is ignored
  even code is ignored
  \echo  'ignored'
  note that the HERE_DOCUMENT text can be changed to any string.
HERE_DOCUMENT
# The HERE_DOCUMENT text must be at the very beginning of the line.
# Omitting the above HERE_DOCUMENT will have the below code ignored as well.
\echo  'not ignored'



# A whole HEREDOC block which can be trivially commented in or out to enable/disable the block.
# Also code foldable.
# My own design!
:<<'}'
{
  \echo  'stuff'
}



\echo
# HEREDOC in a variable
variable=$(cat <<'SETVAR'
This variable
runs over multiple lines.
SETVAR
)
\echo  "$variable"
