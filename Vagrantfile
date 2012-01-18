Vagrant::Config.run do |config|
  
  config.vm.box = "lucid32"
  config.vm.box_url = "http://files.vagrantup.com/lucid32.box"
  
  config.vm.provision :puppet do |puppet|
    puppet.manifest_file = "sentry.pp"
  end
  
  config.vm.forward_port "web", 80, 4567
end
