easysoa-proxy-event-ui 
=======================

EasySOA event monitoring Subscription UI

This application is a prototype of one of the features EasySOA can allows to users.  
This application is ruby based, specially rails which is a very popular web framework.

Lets talk about how it works. this application  has many requirements:

- Download and install Ruby(1.9.3) and Rails http://rubyonrails.org/

- After installing ruby and rails install thin server by running: sudo gem install thin

- Get easysoamonitoringrails from Github
    - git clone git@github.com:easysoa/easysoa-proxy-event-ui.git
       
    - git clone https://github.com/easysoa/easysoa-proxy-event-ui.git

- Build EasySOA

- Run EasySOA

- Connect to the registry as Administrator

- Reach the Consumer configuration following this way:

	Admin Panel-> Oauth/OpenSocial -> Consumer -> Add.

	Then add a new consumer. By default use key = "bob" and secret "bob" for allow the rails application to exchange with the registry. You can set others values but you should set the same values in the application controllers which is in the app/controllers/application_controller.rb  

- Enter from the terminal in the easysoamonitoringrails folder downloaded then run in order theses commands:
	- Run `bundle install`      To install all the requires gems needed by the RoR aplication
	- Run `rake db:create`      To create the sqlite database
	- Run `rake db:migrate`	    To create all the tables required for the aplication
	- Run `rake db:seed`		To insert some default data about roles(By default 2 roles: Business Users and Power Users )


- Run the Application:

	- Run `thin start`

For change NXql requests: file app/config/initializers/configvariables.rb

More about EasySOA: https://github.com/easysoa

