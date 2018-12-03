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


#Plot this in a pie chart too
followerLanguagesPie = plot_ly(data = repo_languages, values =~Freq, labels=~Var1, type = "pie",
                       textposition = 'inside', textinfo = 'label+percent', showlegend = FALSE) %>%
  layout(title = 'Languages used by Followers',
         xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
         yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))

followerLanguagesPie_link = api_create(followerLanguagesPie, filename = "followerLanguages")
followerLanguagesPie_link

#RATIO OF FOLLOWING:FOLLOWERS
#Here's a function that produces a bar chart of that users ratio of following to followers. 
barChart = function(username){
  
  x = c("Following", "Followers")
  y = c(numFollowing(username), numFollowers(username))

  p <- plot_ly(data, x = ~x, y = ~y, type = 'bar', 
               text = y, textposition = 'auto',
               marker = list(color = 'rgb(158,202,225)',
                             line = list(color = 'rgb(8,48,107)', width = 1.5))) %>%
    layout(title = "Following:Followers Ratio",
           xaxis = list(title = ""),
           yaxis = list(title = ""))
  
  return(p)
}

x = barChart("paulirish")
xlink = api_create(x, filename = "followingfollowerratio")

#BUILD A NETWORK OF USERS-----------------------------------------------------------------------

#Only going to take 10 followers from each user, then move onto the next
userfollowers = jsonlite::fromJSON(paste0(userslink, username, followinglink, perpagelink, "10"))
list = userfollowers$login

allUsers = c()

masterDataFrame = data.frame(username = integer(), numFollowers = integer(), numFollowing = integer(),
                             numRepos = integer(), dateCreated = integer(), lastActive = integer())

for(i in 1:length(list))
{
  activeUser = list[i]
  
  activeUserFollowers = jsonlite::fromJSON(paste0(userslink, username, followinglink, perpagelink, "10"))
  activeFollowerList = activeUserFollowers$login
  
  if(length(activeFollowerList) == 0)
  {
    next
  }
  
  for(j in 1:length(activeFollowerList))
  {
    login = activeFollowerList[j]
    
    if(any(login %in% allUsers)){}
    else{
      masterDataFrame[nrow(masterDataFrame)+1, ] = c(login, numFollowers(login), numFollowing(login),
                                                     numRepos(login), dateCreated(login), 
                                                     lastActive(login))
    }
    
    if(length(allUsers) > 100){break}
    next
  }
  next
}


#Plot NUMBER OF REPOSITORIES vs NUMBER OF FOLLOWERS --------------------------------------------
#Before visualising the data, I'd intuitively expect that more active followers (shown by how
#many repositories they have) would have more followers. 
scatter <- plot_ly(data = masterDataFrame, x =~numRepos, y = ~numFollowers,
              type = "scatter",
             text = ~paste("Repositories: ", numRepos, '<br>Followers: ', numFollowers),
             marker = list(size = 10,
                           color = 'rgba(255,102,255,0.2)',
                           line = list(color = 'rgba(152, 0, 0, .8)',
                                       width = 2))) %>%
  layout(title = 'Number of Repositories vs Number of Followers',
         yaxis = list(zeroline = FALSE),
         xaxis = list(zeroline = FALSE))

scatterLink = api_create(scatter, fileName = "followersRepositories")
scatterLink

#You might also expect more active users to follow more people, so lets plot the
#NUMBER OF REPOSITORIES vs NUMBER FOLLOWING too
scatter2 <- plot_ly(data = masterDataFrame, x =~numRepos, y = ~numFollowing,
                   type = "scatter",
                   text = ~paste("Repositories: ", numRepos, '<br>Following: ', numFollowers),
                   marker = list(size = 10,
                                 color = 'rgba(255,102,255,0.2)',
                                 line = list(color = 'rgba(152, 0, 0, .8)',
                                             width = 2))) %>%
  layout(title = 'Number of Repositories vs Number Following',
         yaxis = list(zeroline = FALSE),
         xaxis = list(zeroline = FALSE))

scatterLink2 = api_create(scatter2, fileName = "followingRepositories")
scatterLink2