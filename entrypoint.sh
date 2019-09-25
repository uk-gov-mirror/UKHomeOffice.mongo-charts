#!/bin/bash

export PATH="$PATH:/mongodb-charts/bin:/mongodb-charts/lib"
export LD_LIBRARY_PATH="$PATH:/mongodb-charts/lib"
charts-cli startup
