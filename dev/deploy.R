# Script for deploying the application to shinyapps.io. It should be run from
# package's root directory after setting environment variables.
rsconnect::setAccountInfo(
  name = Sys.getenv("SHINYAPPS_NAME"),
  token = Sys.getenv("SHINYAPPS_TOKEN"),
  secret = Sys.getenv("SHINYAPPS_SECRET")
)

rsconnect::deployApp(
  appName = "ShinyShips",
  forceUpdate = TRUE
)
