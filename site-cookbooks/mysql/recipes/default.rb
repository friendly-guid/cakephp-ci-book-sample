execute "mysql-create-user" do
    command "/usr/bin/mysql -u root --password=\"#{node['example']['db']['rootpass']}\"  < /tmp/grants.sql"
    action :nothing
end

template "/tmp/grants.sql" do
    owner "root"
    group "root"
    mode "0600"
    variables(
        :user     => node['example']['db']['user'],
        :password => node['example']['db']['pass'],
        :database => node['example']['db']['database']
    )
    notifies :run, "execute[mysql-create-user]", :immediately
end

package "libmysql++-dev" do
    action :install
end

chef_gem "mysql" do
    action :nothing
    subscribes :install, "package[libmysql++-dev]", :immediately
end


# MySQLのサービスを有効化して起動する
service "mysql" do
    action [:enable, :restart]
    supports :status => true, :start => true, :stop => true, :restart => true
    not_if do File.exists?("/var/run/mysqld/mysqld.pid") end
end


%w{
  blog
  test_blog
}.each do |database| 
  execute "mysql-create-database" do
      command "/usr/bin/mysql -uroot -p#{node['example']['db']['rootpass']} -e 'create DATABASE #{database} DEFAULT CHARACTER SET utf8'"
      not_if do
	      print "----#{database}-----"
          require 'rubygems'
          Gem.clear_paths
          require 'mysql'
          m = Mysql.new(node['example']['db']['host'], "root", node['example']['db']['rootpass'])
          m.list_dbs.include?("#{database}")
      end
  end
end
