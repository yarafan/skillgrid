# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.delete_all
Product.delete_all
a = User.create(name: 'Admin', email: 'admin@mail.com',
                password: '1111111111', password_confirmation: '1111111111')
o = User.create(name: 'Owner', email: 'owner@mail.com',
                password: '11111111', password_confirmation: '11111111', shop: 'Shop')
g = User.create(name: 'Guest', email: 'guest@mail.com',
                password: '111111', password_confirmation: '111111')
g1 = User.create(name: 'Guest1', email: 'guest@mail.ru',
                 password: '111111', password_confirmation: '111111')
a.toggle!(:admin)
g.toggle!(:guest)
g1.toggle!(:guest)
o.toggle!(:owner)
p = Product.create(title: 'Some product', description: 'Some description', shop_title: o.shop, user_id: o.id)
Product.create(title: 'Some product(not pro)', description: 'Some description', shop_title: o.shop, user_id: o.id)
p.toggle!(:pro)
