Fyber R-Project
===============

  This challenge was made using Ruby 2.0.0 with [Sinatra](http://www.sinatrarb.com/) and
[Rspec](http://rspec.info/). 

Setup
-----
  1. Clone the repo
  2. Run `bundle install` from the repository directory
  3. Run `ruby app.rb`
  4. [Open the page]("http://localhost:4567/packages")
  5. If you want to load the packages run `rake search_packages`. You
     can see the process on `log/output.log` file
     **NOTE:** this can take some time because it has to read each
tar.gz file.

Testing
-------
  Run `rspec spec`

Config
-------
  You can change the settings for load more than 50 packages on `config/config.rb`
file

Notes
------
  * This app is on [heroku](http://r-packages.herokuapp.com/packages) but
for now it doesn't have any package for [problems with
dyno](https://devcenter.heroku.com/articles/error-codes#r14-memory-quota-exceeded) when runs the rake task for load packages. This error is being investigated
 




