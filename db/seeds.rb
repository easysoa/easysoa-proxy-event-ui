# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

test = SubscriptionType.create([{description: 'Added By Administrators', title: 'By Administrators'}])
defaultProxy = Proxy.create([{title: 'localhost:8081', url: 'http://127.0.0.1:8081'}])

defaultRolePowerUser = Role.create([{title: 'PowerUser'}])
defaultBusinessUser = Role.create([{title: 'BusinessUser'}])


#defaultAccountBusinessUser = User.create([{ firstname: 'Administrator' , lastname=> 'Administrator', password=>'Administrator'}])


@user = User.new(:firstname => 'Administrator', :username => 'Administrator', :lastname => 'Administrator', :password => 'Administrator')
@user.role = Role.where(:title => 'PowerUser')[0]
@user.save
