#
# Cookbook Name:: fluentd
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
if (node['fluentd']['installer'] == "rpm")
  execute "install td-agent by using rpm" do
    command "curl -L http://toolbelt.reasure-data.com/sh/install-redhat.sh | sh"
  end
  template "fluentd.conf.erb" do
    path    "/etc/td-agent/td-agent.conf"
    source  "fluent.conf.erb"
    owner   "root"
    group   "root"
    mode    "0644"
    notifies :restart, "service[td-agent]"
  end
else
  execute "gem install fluentd" do
    command "/home/#{node['fluentd']['user']}/.rbenv/shims/gem install fluentd --no-ri --no-rdoc"
    user node['fluentd']['user']
    group node['fluentd']['group']
    environment 'HOME' => "/home/#{node['fluentd']['user']}"
  end
  execute "fluentd --setup ./fluent" do
    command "/home/#{node['fluentd']['user']}/.rbenv/shims/fluentd --setup /home/#{node['fluentd']['user']}/fluent"
    user node['fluentd']['user']
    group node['fluentd']['group']
    environment 'HOME' => "/home/#{node['fluentd']['user']}"
    not_if { File.exists?("/home/#{node['fluentd']['user']}/fluent") }    
  end
end
