puts 'creating sites'
bg = Site.create name: 'begoaled', display_name: 'BeGoaled', domain: 'begoaled.com', is_app_host: true
lchst = Site.create name: 'localhost', display_name: 'Local Host', domain: 'localhost'
sub = Site.create name: 'subdomain', display_name: 'A SubDomain Site'

puts 'creating gk'
u = User.create name: 'Gk', email: 'gk@localhost.com', password: '1234'

r = Role.create name: 'admin'
u.roles << r
