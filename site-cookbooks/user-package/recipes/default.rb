execute "install-user-plugin" do
  command <<-_EOH_
    sudo apt-get install -y python-dev
    sudo apt-get install -y python-pip
    sudo pip install mycli
  _EOH_
  action :run
end
