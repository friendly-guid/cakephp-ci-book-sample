package "ruby2.0" do
  action :install
end

gem_package "capistrano" do
  gem_binary("/usr/bin/gem2.0")
  action :install
end
