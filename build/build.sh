#!/bin/bash
unzip -o ./GetuiAne.swc
rm ./catalog.xml
cp -v ./library.swf ./Android-ARM
cp -v ./library.swf ./Android-x86
cp -v ./library.swf ./iPhone-ARM

adt -package -target ane aneGetuiPushNotification.ane extension.xml -swc GetuiAne.swc -platform iPhone-ARM -platformoptions platformIOSARM.xml -C iPhone-ARM . -platform Android-ARM -C Android-ARM . -platform Android-x86 -C Android-x86 . -platform default -C ./ library.swf