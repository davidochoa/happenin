Happenin App
========================

[![wercker status](https://app.wercker.com/status/86105c6c96902df83470f6aac8221afd/m/develop "wercker status")](https://app.wercker.com/project/bykey/86105c6c96902df83470f6aac8221afd)

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
