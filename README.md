# CS3012

This repository contains the code related content for CS3012's coursework. 

Note: For the earlier assignments, I was intially going to use Java but opted to learn **Python** instead. The assignments related to the
Github Access have been done through **R**. 

### Lowest Common Ancestor
To implement a function that can calculate the lowest common ancestor in a graph, that may be structured as a binary tree.

Relevant Files: LCA.py, test_lca_unittest.py

### Lowest Common Ancestor 2 
Enhanced the previous LCA solution, implementating it in a way that can work for graphs structured in directed acyclic form.

Relevant Files: DAG.py, test_lca_dag.py

### Github Access
Interrogate the GitHub API to retrieve and display data regarding the logged in developer. This simply prints details about the 
user in the R console, but has been further developed in the following assignment. 

Relevant Files: github_access.R

### Social Graph
Building on the previous assignment to visualise the data.  

Relevant Files: github_interrogation.R

I used Plotly to create these visualisations, including
* A pie chart of a user's repository languages
* A pie chart of the languages used in the repositories of that user's followers. 
_Naturally, you'd expect that people are following users that create repositories in languages they're interested in, 
so it's interesting to compare these pie charts_
* A bar chart of the user's ratio of following:followers (A simple graph created by simply passing in the username)
* A scatter plot of a user's number of repositories and number of followers
* A scatter plot of a user's number of repositories and number following
_Here, you'd expect that increased activity (evidenced by the number of repositories) would lead to more followers and 
following_

Example of a plot:
![alt text](https://raw.githubusercontent.com/username/projectname/branch/path/to/img.png)
