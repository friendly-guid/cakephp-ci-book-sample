execute "add-jenkins-repo" do
  command <<-EOH
    wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
    sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
    apt-get update
  EOH
  action :run
end

package "jenkins" do
  action :install
end

service "jenkins" do
  action [:enable, :start]
end
