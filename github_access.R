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

# Convert to a data.frame
gitDF = jsonlite::fromJSON(jsonlite::toJSON(json1))

# Subset data.frame
gitDF[gitDF$full_name == "dugganl1/datasharing", "created_at"] 

#NOW LET'S INTERROGATE MY OWN PROFILE TO EXTRACT SOME DETAILS
#Profile Details
me = fromJSON("https://api.github.com/users/dugganl1")
name = me$name
id = me$id
username = me$login
company = me$company
num_followers = me$followers
num_following = me$following
num_public_repo = me$public_repos
date_account_created = me$created_at
email = me$email
location = me$location
last_activity = me$updated_at
hireable = me$hireable

#Print out the data in a readable manner
cat("Github Profile Details",
    "\nName: ", name,
    "\nUser ID: ", id,
    "\nUsername: ", username,
    "\nEmail: ", email,
    "\nCompany: ", company, 
    "\nFollowers: ", num_followers,
    "\nFollowing: ", num_following,
    "\nNumber of Public Repositories: ", num_public_repo,
    "\nAcount Created: ", date_account_created,
    "\nLast Activity: ", last_activity,
    "\nLocation: ", location, 
    "\nHireable?: ", hireable)


#Repositories Details
myrepos = fromJSON(me$repos_url)
repo_names = myrepos$name
languages = myrepos$language
created = myrepos$created_at
description = myrepos$description
num_forks = myrepos$forks_count
num_watchers = myrepos$watchers

#Print out the data in a readable manner
cat("Repository Details")
for(i in 1:length(repo_names))
{
  cat("Repository Name: ", repo_names[i],
      "\nLanguage: ", languages[i],
      "\nDate Created: ", created[i],
      "\nDescription: ", description[i],
      "\nForks: ", num_forks[i],
      "\nWatchers: ", num_watchers[i], "\n\n")
}

#Followers Details
myfol = fromJSON(me$followers_url)
followers_usernames = myfol$login

#Print out the data in a readable manner
cat("My Followers: ", followers_usernames)

#INTERROGATING AN ORGANISATION - e.g. Facebook
org = fromJSON("https://api.github.com/orgs/facebook")
org_name = org$name
org_username = org$login
blog = org$blog
num_public_repos = org$public_repos
orgmembers = fromJSON("https://api.github.com/orgs/facebook/members")
members_usernames = orgmembers$login
num_members = length(members_usernames)

#Print out Organisation Details in a readable manner
cat("Organisation Name: ", org_name,
    "\nUsername: ", org_username,
    "\nNumber of Members: ", num_members,
    "\nBlog: ", blog, 
    "\nPublic Repositories: ", num_public_repo, 
    "\nMember Usernames: ", members_usernames)
