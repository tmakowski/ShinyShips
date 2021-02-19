#!/bin/sh
set -e

R CMD INSTALL --no-multi-arch --with-keep.source .
Rscript -e 'ShinyShips::run_app(port = 8080)'
