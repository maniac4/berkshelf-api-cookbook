default[:berkshelf_api][:endpoints][:chef_server] = [
  {
   :url => "https://chef1",
   :client_name => "berkshelf-api",
   :client_key => "#{node[:berkshelf_api][:home]}/.keys/chef1.pem",
   :ssl_verify => false
  },
  {
   :url => "https://chef2",
   :client_name => "berkshelf-api",
   :client_key => "#{node[:berkshelf_api][:home]}/.keys/chef2.pem",
   :ssl_verify => false
  }
]
