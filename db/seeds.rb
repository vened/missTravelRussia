# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# CreateUsersService.new.call
CreateUsersService.new.create_admin
# CreateUsersService.new.create_users
# if ENV["userId"]
#   CreateUsersService.new.update_votes(ENV["userId"])
# end


# users = User.where(_role: 'contestant')
# users.each do |user|
#   unless user.is_disqualify
#     user.update(is_disqualify: false)
#     user.save(validate: false)
#   end
# end
