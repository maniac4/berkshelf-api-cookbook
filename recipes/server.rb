#
# Cookbook Name:: berkshelf
# Recipe:: server
#
# Copyright (C) 2013-2014 Jamie Winsor
#
# Customized by maniac for centos system

include_recipe "libarchive::default"

chef_gem "bundler"

group node[:berkshelf_api][:group]

user node[:berkshelf_api][:owner] do
  home node[:berkshelf_api][:home]
  gid node[:berkshelf_api][:group]
  shell "/sbin/nologin"
end

directory node[:berkshelf_api][:home] do
  owner node[:berkshelf_api][:owner]
  group node[:berkshelf_api][:group]
  recursive true
end

template node[:berkshelf_api][:config] do
  owner node[:berkshelf_api][:owner]
  group node[:berkshelf_api][:group]
  source "opt/berkshelf-api/config.json.erb"
end

asset = github_asset "berkshelf-api.tar.gz" do
  repo node[:berkshelf_api][:repo]
  release node[:berkshelf_api][:release]
end

libarchive_file "berkshelf-api.tar.gz" do
  path asset.asset_path
  extract_to node[:berkshelf_api][:deploy_path]
  extract_options :no_overwrite
  owner node[:berkshelf_api][:owner]
  group node[:berkshelf_api][:group]
  action :extract
  notifies :run, "execute[rebuild-symlink]"
  only_if { ::File.exist?(asset.asset_path) }
end

execute "berkshelf-api-bundle-install" do
  user node[:berkshelf_api][:owner]
  group node[:berkshelf_api][:group]
  cwd node[:berkshelf_api][:deploy_path]
  command "/opt/chef/embedded/bin/bundle install --deployment --without development test"
  not_if "cd #{node[:berkshelf_api][:deploy_path]} && /opt/chef/embedded/bin/bundle check"
end

execute "rebuild-symlink" do
  user node[:berkshelf_api][:owner]
  group node[:berkshelf_api][:group]
  action :nothing
  command "unlink #{node[:berkshelf_api][:release_symlink]} ; ln -s #{node[:berkshelf_api][:deploy_path]} #{node[:berkshelf_api][:release_symlink]}" 
end

# This file will be until Jamie Winsor will apply my pull request here : https://github.com/berkshelf/berkshelf-api/pull/124 ###############
cookbook_file "#{node[:berkshelf_api][:deploy_path]}/lib/berkshelf/api/srv_ctl.rb" do
  user node[:berkshelf_api][:owner]
  group node[:berkshelf_api][:group]
  source "opt/berkshelf-api/current/lib/berkshelf/api/srv_ctl.rb"
end
############################################################################################################################################

directory "#{node[:berkshelf_api][:home]}/.keys" do
  user node[:berkshelf_api][:owner]
  group node[:berkshelf_api][:group]
  mode 0700
end

node[:berkshelf_api][:endpoints][:chef_server].each do |key|
  cookbook_file key.fetch(:client_key) do
    user node[:berkshelf_api][:owner]
    group node[:berkshelf_api][:group]
    mode 0600
  end
end

template "/etc/init.d/berkshelf-api" do
  user "root"
  group "root"
  mode 0755
  source "etc/init.d/berkshelf-api.erb"
  variables(
    :cookbook_name => @cookbook_name
  )
end

#include_recipe "monit::service"

#template "/etc/monit.d/#{cookbook_name}.conf" do
#  owner "root"
#  group "root"
#  mode 0600
#  source "etc/monit.d/#{cookbook_name}.conf.erb"
#  variables(
#    :local_ip => local_ip
#  )
#  notifies :restart, "service[monit]"
#end
