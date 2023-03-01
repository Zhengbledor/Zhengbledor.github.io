#!/bin/sh

hugo -D
git add .
git commit -m "update"
git push