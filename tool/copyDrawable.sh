#!/bin/bash

find drawable*dpi/ -name $2 | xargs -I {} cp  {} $1/src/main/res/{}
