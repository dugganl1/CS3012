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
gh(x$repos_url)


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
  list = gh(user$followers_url, .limit = 100)
  
  if(numFollowers(username) > 0)
  {
    followers = vector()
    for(i in 1:numFollowers(username))
    {
      followers = c(followers, list[[i]]$login)
    }
    
    return(followers)
  }
  
  return("No Followers")
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
  
  
  if(numFollowing(username) > 0)
  {
    following = vector()
    
    for(i in 1:numFollowing(username))
    {
      following = c(following, list[[i]]$login)
    }
    
    return(following)
  }
  
  return("Not following anybody")
}
following("dugganl1")

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

#Number of public repositories? 
numRepos = function(username)
{
  user = gh(paste(userslink, username, sep = ""))
  num = user$public_repos
  return(num)
}

#List these repositories by name
listRepos = function(username)
{
  user = gh(paste(userslink, username, sep = ""))
  list = gh(user$repos_url)
  
  listRepos = vector()
  for(i in 1:numRepos(username))
  {
    listRepos = c(listRepos, list[[i]]$name)
  }
  
  return(listRepos)
}

#Languages of these repositories 
listLanguages = function(username)
{
  user = gh(paste(userslink, username, sep = ""))
  list = gh(user$repos_url)
  
  listLanguages = vector()
  for(i in 1:numRepos(username))
  {
    listLanguages = c(listLanguages, list[[i]]$language)
  }
  
  return(listLanguages)
}

#LOCATION DATA----------------------------------------------------------------------------------
#I want to get the location of someone's followers (if they provide it) and plot these on a map/barchart. 
#More interesting to choose an account with lots of followers. 
#User: "gitser"





#LANGUAGE DATA----------------------------------------------------------------------------------
#Are the most popular languages of one user related to the most popular languages among his/her
#followers?
listLanguages("afshinea")

followers("dugganl1")

#BUILD A NETWORK of users in a Matrix-----------------------------------------------------------
networkmatrix = matrix(NA, 250, 6)
length = 0

buildUserNetwork = function(username){
  networkmatrix[1,0] = c(username, numFollowers(username), numFollowing(username), 
                         location(username), dateCreated(username), lastActive(username))
  length = length + 1
  
}



#--PLOTLY UPLOAD--------------------------------------------------------------------------------
Sys.setenv("plotly_username"="dugganl1")
Sys.setenv("plotly_api_key"="tVrk2miiCJ70HGlCczH1")


#LINKS TO PLOTS---------------------------------------------------------------------------------