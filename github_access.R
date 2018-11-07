#Install the necessary packages (if they're not already installed)
#install.packages("jsonlite")
#install.packages("httpuv")
#install.packages("httr")

#Call the libraries
library(jsonlite)
library(httpuv)
library(httr)

#In this case its "github", but it can also be changed to "linkedin" etc. depending on the application
oauth_endpoints("github")

# Change based on what you 
myapp <- oauth_app(appname = "Access_Github",
                   key = "c9f6512c3f31d1aa3903",
                   secret = "d7d44751a94ae1971a4fae279446f7cf6c6b4d5f")

# Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)

# Take action on http error
stop_for_status(req)

# Extract content from a request
json1 = content(req)

# Convert to a data.frame
gitDF = jsonlite::fromJSON(jsonlite::toJSON(json1))

# Subset data.frame
gitDF[gitDF$full_name == "jtleek/datasharing", "created_at"] 
