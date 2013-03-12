#
# Cookbook Name:: ow_etherpad
# Recipe:: default
#
# Copyright 2013, OpenWatch FPC
#
# Licensed under AGPLv3
#

secrets = Chef::EncryptedDataBagItem.load(node['ow_etherpad']['secret_databag_name'] , node['ow_etherpad']['secret_databag_item_name'])

db_name = 'etherpad'

# Setup postgresql database
postgresql_database db_name do
  connection ({
        :host => "127.0.0.1", 
        :port => node['postgresql']['config']['port'], 
        :username => "postgres", 
        :password => node['postgresql']['password']['postgres']})
  action :create
end

node.set['etherpad-lite']['default_text'] = "This is an OpenWatch collaborative investigation pad. Put your findings here!\\n\\nThis is deep and wide, document-based journalism, so don't be afraid to post your findings in their entirety.\\n\\nWhat happened?\\n\\nWho is involved, and what do they have to say about it?\\n\\nWhy are they saying that?\\n\\nWhat's going to happen next?\\n\\n======== CONTACTS ==========\\n\\n * Name:  \\n * Title:  \\n * Phone number:  \\n * Email:  \\n * Facebook:  \\n * Twitter:  \\n\\nDemand marvelous secrets!"
node.set['etherpad-lite']['db_name'] = db_name
node.set['etherpad-lite']['db_type'] = 'postgres'
node.set['etherpad-lite']['db_password'] = node['postgresql']['password']['postgres']
node.set['etherpad-lite']['etherpad_api_key'] = secrets['APIKEY']
node.set['etherpad-lite']['admin_password'] = secrets['admin_password']
node.set['etherpad-lite']['etherpad_git_repo_url'] = 'git://github.com/OpenWatch/etherpad-lite.git'
node.set['etherpad-lite']['ssl_key_path'] = '/srv/ssl/myserver.key'
node.set['etherpad-lite']['ssl_cert_path'] = '/srv/ssl/star_openwatch_net2.crt'

include_recipe "etherpad-lite"

