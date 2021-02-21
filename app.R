# This file is used by the dev/deploy.R script.
pkgload::load_all(export_all = FALSE, helpers = FALSE, attach_testthat = FALSE)
ShinyShips::run_app()
