#!/bin/bash

echo "$CHARTS_MONGODB_URI" > /run/secrets/charts-mongodb-uri

export PATH="$PATH:/mongodb-charts/bin:/mongodb-charts/lib"
export LD_LIBRARY_PATH="$PATH:/mongodb-charts/lib"
charts-cli startup
