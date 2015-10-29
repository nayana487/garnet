[![Travis](https://travis-ci.org/ga-dc/garnet.svg?branch=master)](https://travis-ci.org/ga-dc/garnet/)

# Garnet

## Local Setup

```
$ git clone https://github.com/ga-dc/garnet
$ cd garnet
$ bundle
$ rake db:create
$ rake db:migrate
$ rake db:seed
$ rails s
```

## current_user

It exists. See the application controller and helper.

## Github Authentication

### Setup

```
bundle exec figaro install
```

[Register a Github application](https://github.com/settings/applications) and update `config/application.yml` to look like this:

```
gh_client_id: "12345"
gh_client_secret: "67890"
gh_redirect_url: "http://localhost:3000/github/authenticate"
```

### Github model

The Github model has an API method. To use it:

```rb
# Gets the current organization's repos
request = Github.new(ENV).api.repos

# Gets the current user's repos
request = Github.new(ENV, session[:access_token]).api.repos
```

It's built on the Octokit gem. For more information [see the Octokit docs](https://github.com/octokit/octokit.rb).

## Tree model

The "Group" model inherits from a "Tree" model, which allows nesting -- that is, for a Group to have child Groups and a parent Group.

## Methods of note

- `User.named`: short for `User.find_by(username: )`
- `@user.role`: returns a specific membership
- `@user.minions`: returns all users of all groups of which the user is a member, who are not admins

## Helpers of note

- Application
  - `color_of`: turns an input number into its corresponding color (for color scales)
  - `percent_of(collection, value)`: how many members of an AR collection are of a certain value

- Group
  - `breadcrumbs(group, user = nil)`: navigation breadcrumbs for a group (optionally with a user on the end)
  - `subgroup_tree_html`: nested `<ul>` of the current group and its subgroups

![The ERD](http://i.imgur.com/jW4WQQK.png)

## User stories

### Github Auth

Users can sign up *with* or *without* Github.

If they sign up *with* Github, they cannot update their username, password, e-mail, etc. Every time they subsequently sign in, the Github API is polled for their most recent information, and the database is updated accordingly.

If they sign up *without* Github, they can update their username, password, e-mail, etc. Should they wish to later link Github to their account, they can click the "Link Github account" link, which will poll the database, rewrite their information in the Users table to use their Github username, email, etc. From there their account will behave as if they had originally signed up with Github.

### Garoot
- Can remove admins from a group

### Admins
- Can create assignments
- Can create submissions linking an assignment to a submission, which links a user to a group

- Can see submissions they have to grade
- Can change a submission status
- Can change a submission to required / not required

- Can see attendances they have to take
- Can change an attendance status

- Can create subgroups, and becomes an admin of that subgroup
- Can add members with or without admin status to a group
  - Adding members to a group causes the user to be made a member of all ancestor groups

### Nonadmins
- Can mark their attendance "present" within 1 hour before the start of an event, and their IP address is logged

- Can see submissions they have to complete
- Can see submission history and summary

- Can see attendances they have to mark
- Can see attendance history and summary

### Student data
- Attendances, submissions, and observations all "bubble up" -- they are factored into the data summaries of parent groups

## Deployment

When commits are pushed or merged via pull request to master on this repo, [Travis](https://travis-ci.org/ga-dc/garnet)
clones the application, runs `bundle exec rake` to run tests specified in `spec/`.

If all tests pass, travis pushes to the production repo: `git@garnet.wdidc.org:garnet.git`

This triggers a `post-update` hook, which pulls from GitHub's master branch and restarts
unicorn, the application server.

## Troubleshooting

### NewRelic

New Relic monitors the app and provides metrics.  They are available in development mode (/newrelic) and production (rpm.newrelic.com).  It is recommended that you [install newrelic-sysmond on the servers](https://rpm.newrelic.com/accounts/1130222/servers/get_started).

"config/newrelic.yml" was downloaded from rpm.newrelic.com and updated to use `<%= app_name %>`
