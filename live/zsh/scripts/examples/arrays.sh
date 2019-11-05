#!/usr/bin/env  zsh
# 
# zsh 5.7.1-1



:<<'}'  #  Pass an array to a function, then iterate through it.
{
  example() {
    for element in ${@[@]}; do
      echo some text $element
    done
  }
  example  "my text" two 3
}



#:<<'}'  #  Add items into an array.
{
  array=
  for i in {1..3}; do
    if [ -z "$array" ]; then
      array="$i x"
    else
      array="$array$IFS$i x"
    fi
  done
  # These all act the same:
  \echo  '---'
  \echo  $array
  \echo  '---'
  \echo  "$array"
  \echo  '---'
  for i in $array; do
    echo $i
  done
  \echo  '---'

  # Some setups may need to fiddle with IFS, but this is not necessary with my testing with zsh 5.7.1-1
  # IFS (Internal Field Separator), change to a carriage return:
  #IFS_original="$IFS"
  #IFS=$( \printf "\r" )
  # (the script)
  # Reset:
  #IFS="$IFS_original"
  
  # This was an alternative one-liner which doesn't work with zsh 5.7.1-1
  # Technically I shouldn't be adding a \r to the beginning of the array, but it doesn't seem to matter.
  #array="$array$( \printf "\r" )$i"
}