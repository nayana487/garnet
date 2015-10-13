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

### Users with an admin membership to a group
- Assignments and submissions
  - Create an assignment for the group
    - Automatically create incomplete submissions for all non-admin members of the group
  - Grade (update) a submission for the group
  - Read (but not create or update) all assignments for sub-groups
  - Read (but not create or update) all submissions for sub-groups
- Groups and memberships
  - Create a sub-group within the group
  - Add admin memberships to the group
  - Add non-admin memberships to the group
  - Edit memberships of the group
- Observations
  - Create an observation for a non-admin member of the group
  - Read (but not create or update) all observations for sub-groups

### All users
- User info
  - Change their password, username, and name
  - Authorize their account for Github API access
- Groups
  - View all groups owners
- Submissions
  - Complete a submission for an assignment (via update)
  - See submissions that they have completed
  - See submissions that have been assigned to (created for) them
- Attendance
  - Mark that they have attended an event
  - See events they have attended
  - See events at which they are expected to attend

### Student

```rb
=begin
if signed_in && gh_db && current_user.id == gh_db.id
  current_user
if signed_in && gh_db && current_user.id != gh_db.id
  "error: gh account already linked"
if signed_in && !gh_db
  current_user
if !signed_in && gh_db
  gh_db_user
if !signed_in && !gh_db
  User.new
=end
```

## Deployment

When commits are pushed or merged via pull request to master on this repo, [Travis](https://travis-ci.org/ga-dc/garnet)
clones the application, runs `bundle exec rake` to run tests specified in `spec/`.

If all tests pass, travis pushes to the production repo: `git@garnet.wdidc.org:garnet.git`

This triggers a `post-update` hook, which pulls from GitHub's master branch and restarts
unicorn, the application server.
