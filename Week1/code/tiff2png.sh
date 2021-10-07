#!/bin/bash

for f in ../data/*.tif;
	do
		echo "converting $f";
		convert "$f" "../results/$(basename "$f" .tif).png";
	done
