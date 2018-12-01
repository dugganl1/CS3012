#I previously used a different approach, but came across this Github Library on Github, called gh
#It's an extremely mnimal client for accessing the Github API
#https://github.com/r-lib/gh
require(gh)
library(plotly)

#These are strings that are regularly needed, so I've assigned them to variables to make the code cleaner
userslink = "/users/"
followerslink = "/followers"
followinglink = "/following"

x = gh(paste(userslink, "dugganl1", sep = ""))
x$

#FUNCTIONS --------------------------------------------------------------------------------------
#Should be able to pass in any username IN QUOTES
#Number of Followers
numFollowers = function(username)
{
  user = gh(paste(userslink, username, sep = ""))
  num_followers = user$followers
  return(num_followers)
}

#List of followers
followers = function(username)
{
  user = gh(paste(userslink, username, sep = ""))
  list = gh(user$followers_url)
  
  followers = vector()
  for(i in 1:numFollowers(username))
  {
    followers = c(followers, list[[i]]$login)
  }
  
  return(followers)
}

#How many are they Following? 
numFollowing = function(username)
{
  user = gh(paste(userslink, username, sep = ""))
  num_following = user$following
  return(num_following)
}

#List of following
following = function(username)
{
  user = paste(userslink, username, sep = "")
  list = gh(paste(user, followinglink, sep= ""))
  
  following = vector()
  for(i in 1:numFollowing(username))
  {
    following = c(following, list[[i]]$login)
  }
  
  return(following)
}
following("hollanco")

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

#When was the last activity? 
lastActive = function(username)
{
  user = gh(paste(userslink, username, sep = ""))
  updated = substring(toString(user$updated_at), 1, 10)
  return(updated)
}
