#!/bin/bash

echo "Enter path to where rt.jar can be found (e.g., the correct JDK)."
echo "At least on a Mac, you can just drag/drop the Processing app here!"
echo "You can also try just hitting enter to ignore this."
read bcpx
flag=""
if [ -z "$bcpx" ]; then
  echo "Proceeding with no bootclasspath."
else
  bcp=$(find "$bcpx" -name rt.jar)
  if [ -z "$bcp" ]; then
    echo "Couldn't find rt.jar."
    exit 1
  fi
  flag="-bootclasspath"
  echo "Using '$bcp'..."
fi

javac -source 1.7 -target 1.7 json/*.java $flag "$bcp"

if [ "$?" -ne 0 ]; then
  echo "Java 1.7 failed.  Trying 1.6."

  javac -source 1.6 -target 1.6 json/*.java $flag "$bcp"

  if [ "$?" -ne 0 ]; then
    echo "Error compiling."
    exit 2
  fi
fi

echo "Jarring..."

jar -cvf ../../json.jar json/*.class

if [ "$?" -ne 0 ]; then
  echo "Error jarring."
  exit 3
fi

echo "Looks good.  You *may* need to restart Processing."
