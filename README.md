Description
===========

Application cookbook example for an [Onddo blog's post](http://blog.onddo.com/blog/2013/06/11/desplegando-una-aplicacion-lamp-con-chef/).

Requirements
============

## Cookbooks:

* apache2
* database
* php

Usage examples
==============

# In the Run List

```json
{
  "name": "NODE-NAME",
  [...]
  "run_list": [
    "recipe[app-myphpsite]"
  ]
}
```

# Via SSH

```bash
$ knife bootstrap NODE-NAME \
  --ssh-user USER \
  --json-attributes '
    { "myphpsite": {
      "version": "3.7.1",
      "database": {
        "password": "my-s3cr3t-p4ss"
      }
    } }' \
  --run-list "recipe[app-myphpsite]" \
  --sudo
```

# Using Amazon EC2

```bash
# Ubuntu 12.04 LTS amd64 in us-east-1 (ami-856f02ec)
$ knife ec2 server create \
  --image ami-856f02ec \
  --ssh-user ubuntu \
  --flavor t1.micro \
  --region us-east-1 \
  --groups testing \
  --node-name app-myphpsite-1 \
  -T Name=app-myphpsite-1 \
  --json-attributes '
    { "myphpsite": {
      "version": "3.7.1",
      "database": {
        "password": "my-s3cr3t-p4ss"
      }
    } }' \
  --run-list 'recipe[app-myphpsite]'
```

Attributes
==========

* `node['myphpsite']['database']['name']` - MySQL database name to create (defaults to "myphpsite")
* `node['myphpsite']['database']['user']` - MySQL user to create (defaults to "myphpsite-user")
* `node['myphpsite']['database']['password']` - MySQL password (not defined by default, needs to be set)
* `node['myphpsite']['version']` - Worpress version to install (defaults to "3.5.1")
* `node['myphpsite']['www_dir']` - Root directory path (defaults to "/var/www")
* `node['myphpsite']['server_name']` - Domain, hostname or a valid address (it is calculated from `ohai` by default, recommended to be set)

Recipes
=======

# app-myphpsite::default

Installs and configures app-myphpsite [PHP](http://php.net/) application. This example installs a [Worpress](http://wordpress.com/) blog.

License and Author
==================

Author:: Onddo Labs, Sl. (<team@onddo.com>)

Copyright:: 2013, Onddo Labs, Sl. (www.onddo.com)

License:: Apache 2.0

