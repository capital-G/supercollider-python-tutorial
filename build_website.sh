#!/bin/sh

rm -rf plantuml-images

pandoc tutorial.rst -o index.html -s --toc --filter pandoc-plantuml
