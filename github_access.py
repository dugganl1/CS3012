from github import Github


guser = "dugganl1"
gpass = "Github2001"

#g = Github('token')
#g = Github(base_url="https://dugganl1/api/v3", login_or_token="c9479aee23f66a2710a2bdc03cd93c6df3b996ce")
g = Github(guser, gpass)

print(g.get_user().email)
