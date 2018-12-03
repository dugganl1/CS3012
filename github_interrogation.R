#Source: Michael Galarnyk - "Accessing Data from Github API using R"

#Install the necessary packages (if they're not already installed)
install.packages("jsonlite")
install.packages("httpuv")
install.packages("httr")

#Call the libraries
library(jsonlite)
library(httpuv)
library(httr)
library(plotly)

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

#Linking to my PlotLy Account
Sys.setenv("plotly_username"="dugganl1")
Sys.setenv("plotly_api_key"="tVrk2miiCJ70HGlCczH1")

#FUNCTIONS--------------------------------------------------------------------------------------
#Number of followers
#These are strings that are regularly needed, so I've assigned them to variables to make the code cleaner
userslink = "https://api.github.com/users/"
followerslink = "/followers"
followinglink = "/following"
perpagelink = "?per_page="

numFollowers = function(username)
{
  user = jsonlite::fromJSON(paste0(userslink, username))
  
  num_followers = user$followers
  return(num_followers)
}

#List of followers
#Will have to revisit using perPage as a limit
followers = function(username)
{
  user = jsonlite::fromJSON(paste0(userslink, username, followerslink))
  list = user$login
  return(list)
}

#How many are they Following? 
numFollowing = function(username)
{
  user = jsonlite::fromJSON(paste0(userslink, username))
  num_following = user$following
  return(num_following)
}

#List of following
following = function(username)
{
  userfol = jsonlite::fromJSON(paste0(userslink, username, followinglink))
  list = userfol$login
  return(list)
}

#Location
location = function(username)
{
  user = jsonlite::fromJSON(paste0(userslink, username))
  location = user$location
  return(location)
}

#When was the account created? 
dateCreated = function(username)
{
  user = jsonlite::fromJSON(paste0(userslink, username))
  created = substring(toString(user$created_at), 1, 10)
  return(created)
}

#When was the last activity? 
lastActive = function(username)
{
  user = jsonlite::fromJSON(paste0(userslink, username))
  updated = substring(toString(user$updated_at), 1, 10)
  return(updated)
}

#Number of public repositories? 
numRepos = function(username)
{
  user = jsonlite::fromJSON(paste0(userslink, username))
  num = user$public_repos
  return(num)
}

#List these repositories by name
listRepos = function(username)
{
  user = jsonlite::fromJSON(paste0(userslink, username))
  list = jsonlite::fromJSON(user$repos_url)$name
  
  return(list)
}

#Languages of these repositories 
listLanguages = function(username)
{
  user = jsonlite::fromJSON(paste0(userslink, username))
  list = jsonlite::fromJSON(user$repos_url)$language
  
  #Remove NA values because I think these will be useless for data visualisation
  list = list[!is.na(list)]
  return(list)
}

#LANGUAGE DATA ---------------------------------------------------------------------------------
#Single User
username = "jeroen"
repo_languages = data.frame(table(as.data.frame(listLanguages(username))))

#Plot a pie chart of the languages used by this user
languagesPie = plot_ly(data = repo_languages, values =~Freq, labels=~Var1, type = "pie",
                       textposition = 'inside', textinfo = 'label+percent', showlegend = FALSE) %>%
                        layout(title = 'Languages Used in Repositories',
                          xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                            yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))

languagesPie_link = api_create(languagesPie, filename = "singleUserLanguages")
languagesPie_link

#Interesting to see if there's a link between his languages and his followers languages
#Picked 100 of his followers!
userfollowers = jsonlite::fromJSON(paste0(userslink, username, followinglink, perpagelink, "100"))
list = userfollowers$login

alllanguages = c()

for(i in 1:length(list))
{
  currentuserlanguages = listLanguages(list[[i]])
  alllanguages = c(alllanguages, currentuserlanguages)
}

repo_languages = data.frame(table(as.data.frame(alllanguages)))

#Removing Frequencies Less than 5 as these don't tell us much!
repo_languages2 = repo_languages[, .I[.N >= 2], by =~Freq]

#Plot this in a pie chart too
followerLanguagesPie = plot_ly(data = repo_languages, values =~Freq, labels=~Var1, type = "pie",
                       textposition = 'inside', textinfo = 'label+percent', showlegend = FALSE) %>%
  layout(title = 'Languages used by Followers',
         xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
         yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))

followerLanguagesPie_link = api_create(followerLanguagesPie, filename = "followerLanguages")
followerLanguagesPie_link

# #BUILD A NETWORK of users in a Matrix-----------------------------------------------------------
# networkmatrix = matrix(NA, 250, 6)
# length = 0
# 
# buildUserNetwork = function(username){
#   
#   networkmatrix[1,] = c(username, numFollowers(username), numFollowing(username), 
#                                   numRepos(username), dateCreated(username), lastActive(username))
#   length = 1
#   
#   while(length < 250)
#   {
#     cat("Username:", username)
#     
#       list = following(username)
#       
#       for(i in 1:min(numFollowing(username), 30))
#       {
#         if(length == 250){break}
#         if(numFollowing(username) == 0){next}
#         else{
#           new = list[[i]]
#           
#           if(any(new %in% networkmatrix[,1])){}
#           else{
#             networkmatrix[length+1, ] = c(new, numFollowers(new), numFollowing(new),
#                                           numRepos(new), dateCreated(new), lastActive(new))
#             length = length + 1
#           }
#         }
#       }
#   }
# 
#   return(networkmatrix)
# }

#BUILD A NETWORK of users in a Matrix-----------------------------------------------------------
#matrix with login name, followers, following
networkmatrix = matrix(NA, 25, 6)
totalusers = 0
max = 150

buildNetwork = function(username){
  networkmatrix[1, ] = c(username, numFollowers(username), numFollowing(username), numRepos(username), dateCreated(username), lastActive(username))
  length = 1
  check = 1
  activeuser = username
  
  while(length<25){
    print(length)
    ###check that this user is following others
    if(numFollowing(activeuser) <= 1 | numFollowing(activeuser)>50){
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
    
  }
  return(networkmatrix)
}

o = buildNetwork("dugganl1")
o

#--PLOTLY UPLOAD--------------------------------------------------------------------------------



#LINKS TO PLOTS---------------------------------------------------------------------------------

