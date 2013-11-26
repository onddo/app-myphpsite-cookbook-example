default['myphpsite']['database']['name'] = 'myphpsite'
default['myphpsite']['database']['user'] = 'myphpsite-user'
default['myphpsite']['database']['password'] = nil
default['myphpsite']['version'] = '3.5.1'
default['myphpsite']['www_dir'] = '/var/www'
default['myphpsite']['server_name'] = if node.has_key?('cloud')
                                        node['cloud']['public_hostname']
                                      else
                                        node['fqdn']
                                      end
