#!/bin/bash

adt -package -target ane GetuiAne.ane extension.xml -swc GetuiAne.swc -platform iPhone-ARM -platformoptions platformIOSARM.xml -C iPhone-ARM . -platform default -C ./ library.swf