# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


user = User.create({
                       first_name: 'Elias',
                       last_name: 'Perez',
                       email: 'eliasjpr@gmail.com',
                       password: 'macaluso',
                       password_confirmation: 'macaluso',
                       business_name: '809 Design Studio, LLC',
                       balance: 100.45,
                       commission: 10.00,
                       account_status: true,
                       sid: "MAZJAZZJRLYTAYYZGWYZ",
                       auth_token: "YmFlNTdhNWY2OWMzYWJmMWY2OWYwOGE5NDMxZTYy",
                       roles: 'SuperAgent',
                       commission_type: "post paid",
                       endpoint_id: "",
                       parent_id: 1
                   })


calling_id = CallingId.create([{call_id: '19173614563', user_id: 1}, {call_id: 'sip:DirectCall130603151838@phone.plivo.com', user_id: 1}])



