#Source: Michael Galarnyk - "Accessing Data from Github API using R"

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
myapp = oauth_app(appname = "Access_Github",
                  key = "c9f6512c3f31d1aa3903",
                  secret = "d7d44751a94ae1971a4fae279446f7cf6c6b4d5f")

# Get OAuth credentials
github_token = oauth2.0_token(oauth_endpoints("github"), myapp)

# Use API
gtoken = config(token = github_token)
req = GET("https://api.github.com/users/dugganl1/repos", gtoken)

# Take action on http error
stop_for_status(req)

# Extract content from a request
json1 = content(req)

#FUNCTIONS--------------------------------------------------------------------------------------
#Number of followers
#These are strings that are regularly needed, so I've assigned them to variables to make the code cleaner
userslink = "https://api.github.com/users/"
followerslink = "/followers"
followinglink = "/following"
perpagelink = "?per_page="

numFollowers = function(username)
{
  user = fromJSON(paste(userslink, username, sep =""))
  
  num_followers = user$followers
  return(num_followers)
}

#List of followers
#Will have to revisit using perPage as a limit
followers = function(username)
{
  followerCount = numFollowers(username)
  user = fromJSON(paste(userslink, username, sep =""))
  userfol = fromJSON(user$followers_url)
  list = userfol$login
  
  return(list)
}

#How many are they Following? 
numFollowing = function(username)
{
  user = fromJSON(paste(userslink, username, sep =""))
  num_following = user$following
  return(num_following)
}

#List of following
following = function(username)
{
  followingCount = numFollowing(username)
  userfol = fromJSON(paste(userslink, username, followinglink, sep = ""))
  list = userfol$login
  return(list)
}

#Location
location = function(username)
{
  user = fromJSON(paste(userslink, username, sep =""))
  location = user$location
  return(location)
}

#When was the account created? 
dateCreated = function(username)
{
  user = fromJSON(paste(userslink, username, sep =""))
  created = substring(toString(user$created_at), 1, 10)
  return(created)
}

#When was the last activity? 
lastActive = function(username)
{
  user = fromJSON(paste(userslink, username, sep =""))
  updated = substring(toString(user$updated_at), 1, 10)
  return(updated)
}

#Number of public repositories? 
numRepos = function(username)
{
  user = fromJSON(paste(userslink, username, sep =""))
  num = user$public_repos
  return(num)
}

#List these repositories by name
listRepos = function(username)
{
  user = fromJSON(paste(userslink, username, sep =""))
  list = fromJSON(user$repos_url)$name
  
  return(list)
}

#Languages of these repositories 
listLanguages = function(username)
{
  user = fromJSON(paste(userslink, username, sep =""))
  list = fromJSON(user$repos_url)$language
  
  return(list)
}

#BUILD A NETWORK of users in a Matrix-----------------------------------------------------------
#matrix with login name, followers, following
networkmatrix = matrix(NA, 250, 6)
totalusers = 0
max = 150

buildNetwork = function(username){
  networkmatrix[1, ] = c(username, numFollowers(username), numFollowing(username), numRepos(username), dateCreated(username), lastActive(username))
  length = 1
  check = 1
  activeuser = username
  
  while(length<250){
    getUser(activeuser)
    print(check)
    print(length)
    ###check that this user is following others
    if(followingCount(activeuser) <= 1 | followingCount(activeuser)>50){
      check = check + 1
    }
    
    ###if we get here, users will be added
    else{
      followingl = followingList(activeuser)
      limit = min(followingCount(activeuser),30)
      for (j in 1:limit){
        if(length ==250){ break }
        else{
          if (any(followingl[[j]] %in% networkmatrix[, 1])) {}
          else{
            new = followingl[[j]]
            networkmatrix[length+1, ] = c(new, numFollowers(new), numFollowing(new), numRepos(new), dateCreated(new), lastActive(new))
            length = length+1
          }
          
        }
      }
    }
    if(activeuser == "cwells"){
      activeuser =  "etrepum"
    }
    else if(activeuser == "antirez"){
      activeuser = "soveran"
    }else if(activeuser == "soveran"){
      activeuser = "cyx"
      check = 3
    }else if(activeuser == "jorrel"){
      activeuser = "FooBarWidget"
    }
    else{
      activeuser = followingl[[check]]
      
    }
    
  }
  return(networkmatrix)
}

o = buildNetwork("dugganl1")
o

#--PLOTLY UPLOAD--------------------------------------------------------------------------------
Sys.setenv("plotly_username"="dugganl1")
Sys.setenv("plotly_api_key"="tVrk2miiCJ70HGlCczH1")


#LINKS TO PLOTS---------------------------------------------------------------------------------
