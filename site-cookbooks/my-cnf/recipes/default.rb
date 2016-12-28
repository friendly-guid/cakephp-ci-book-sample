template "/etc/my.cnf" do
  user 'root'
  group 'root'
  mode 644
  source 'my.cnf.erb'
end