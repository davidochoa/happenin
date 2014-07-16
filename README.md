Happenin App
========================

[![wercker status](https://app.wercker.com/status/3fed7ce6658cefbe1698f4f2723d7b03/m/develop "wercker status")](https://app.wercker.com/project/bykey/3fed7ce6658cefbe1698f4f2723d7b03)

Happenin web application

TODO: Descriptive information

SETUP
----

### Database
* create db role 'happenin'
* run 'rake db:reset'
* run 'rake db:migrate'

* Should be able to start the server

### Environment variables
#### Environment variables are handled with [dotenv](https://github.com/bkeepers/dotenv) gem
- DB_DATABASE
- DB_HOST
- DB_USERNAME
- DB_PASSWORD
