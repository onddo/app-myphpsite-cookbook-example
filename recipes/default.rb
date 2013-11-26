#
# Cookbook Name:: app-myphpsite
# Recipe:: default
#
# Copyright 2013, Onddo Labs, Sl.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Incluimos las recetas necesarias de los Library Cookbook
include_recipe 'apache2::default'
include_recipe 'apache2::mod_php5'
include_recipe 'database::mysql'
include_recipe 'mysql::server'

# Comprobamos que la contraseña está bien configurada

unless node['myphpsite']['database']['password'].kind_of?(String) and
       node['myphpsite']['database']['password'].length > 8
  raise "You must set the attribute `node['myphpsite']['database']['password']` to a secure password string."
end

# Instalamos php-mysql

case node['platform_family']
when 'centos', 'redhat', 'amazon' then
  if node['platform_version'].to_f < 6.0
    package 'php53-mysql'
  else
    package 'php-mysql'
  end
when 'scientific', 'fedora' then
  package 'php-mysql'
else
  package 'php5-mysql'
end

# Creamos y configuramos la base de datos

# Creamos una variable con los datos de nuestra conexión a MySQL
mysql_connection_info = {
  :host => 'localhost',
  :username => 'root',
  # la contraseña de MySQL es generada internamente por el cookbook de mysql:
  :password => node['mysql']['server_root_password']
}

# Creamos la base de datos
mysql_database node['myphpsite']['database']['name'] do
  connection mysql_connection_info
  action :create
end

# Creamos el usuario de MySQL
mysql_database_user node['myphpsite']['database']['user'] do
  connection mysql_connection_info
  database_name node['myphpsite']['database']['name']
  host 'localhost'
  password node['myphpsite']['database']['password']
  privileges [:all]
  action :grant
end

# Descargamos nuestra aplicación PHP

# remote_file '/tmp/wordpress.tar.gz' do
#   # la URL de descarga de nuestra aplicacion
#   source 'http://wordpress.org/wordpress-3.5.1.tar.gz'
# end
# 
# execute 'tar xzf /tmp/wordpress.tar.gz' do
#   cwd node['myphpsite']['www_dir']
# end
# 
# execute 'rm /tmp/wordpress.tar.gz'

directory '/opt/wordpress' # creamos el directorio

package 'git' # nos aseguramos de tener git instalado

deploy '/opt/wordpress' do
  repo 'git://github.com/WordPress/WordPress.git'
  revision node['myphpsite']['version']
  scm_provider Chef::Provider::Git

  # vaciamos algunos valores orientados a despliegues de RoR
  symlink_before_migrate.clear
  create_dirs_before_symlink.clear
  purge_before_symlink.clear
  symlinks.clear
end

link "#{node['myphpsite']['www_dir']}/wordpress" do
  to '/opt/wordpress/current'
end

# Creamos los ficheros de configuración que necesita nuestra aplicación

template "#{node['myphpsite']['www_dir']}/wordpress/wp-config.php" do
  owner node['apache']['user']
  variables(
    :mysql_db   => node['myphpsite']['database']['name'],
    :mysql_user => node['myphpsite']['database']['user'],
    :mysql_pass => node['myphpsite']['database']['password']
  )
end

# Creamos el virtualhost de Apache

web_app 'myphpsite' do
  cookbook 'apache2'
  docroot "#{node['myphpsite']['www_dir']}/wordpress"
  server_name node['myphpsite']['server_name']
  server_aliases []
  port '80'
  enable true
end

