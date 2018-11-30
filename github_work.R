#I previously used a different approach, but came across this Github Library on Github, called gh
#It's an extremely mnimal client for accessing the Github API
#https://github.com/r-lib/gh
require(gh)
library(plotly)

#These are strings that are regularly needed, so I've assigned them to variables to make the code cleaner
userslink = "/users/"
followers = "/followers"
following = "/following"

x = gh(paste(userslink, "dugganl1", sep = ""))
x$created_at

#FUNCTIONS --------------------------------------------------------------------------------------
#Should be able to pass in any username IN QUOTES
#Number of Followers
numFollowers = function(username)
{
  user = gh(paste(userslink, username, sep = ""))
  followers = user$followers
  return(followers)
}

#List of followers
followers = function(username)
{
  
}

#How many are they Following? 
numFollowing = function(username)
{
  user = gh(paste(userslink, username, sep = ""))
  following = user$following
  return(following)
}

#Location
location = function(username)
{
  user = gh(paste(userslink, username, sep = ""))
  location = user$location
  return(location)
}

#When was the account created? 
dateCreated = function(username)
{
  user = gh(paste(userslink, username, sep = ""))
  created = substring(toString(user$created_at), 1, 10)
  return(created)
}
dateCreated("dugganl1")

#When was the last activity? 
lastActive = function(username)
{
  user = gh(paste(userslink, username, sep = ""))
  updated = substring(toString(user$updated_at), 1, 10)
  return(updated)
}
lastActive("dugganl1")