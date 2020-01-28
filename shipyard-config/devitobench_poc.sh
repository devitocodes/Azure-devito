#!/bin/bash

# This bash scripts takes 2 arguments:
# Arg1 is installation path of shipyard
# Arg2 is the crentials file name

$1/shipyard pool add --credentials $2
$1/shipyard jobs add --credentials $2
$1/shipyard pool del --credentials $2
