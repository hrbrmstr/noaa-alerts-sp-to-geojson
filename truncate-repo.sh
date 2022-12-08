#!/bin/bash
git checkout --orphan new-shapefile &&  \
  git add -A &&  \
  git commit -m "pruning repo" && \
  git branch -D batman && \
  git branch -m batman && \
  git push -f origin batman  && \
  git gc --aggressive --prune=all
