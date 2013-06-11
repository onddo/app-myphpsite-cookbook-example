app-myphpsite Cookbook
======================

Application cookbook example for the [Onddo Labs blog](http://blog.onddo.com/).

# Ubuntu 12.04 LTS amd64 in us-east-1
$ knife ec2 server create \
  -I ami-856f02ec \
  -x ubuntu \
  -f t1.micro \
  --region us-east-1 \
  -G testing \
  -N app-myphpsite-1 \
  -T Name=app-myphpsite-1 \
  -r 'recipe[app-myphpsite]'


e.g.
This cookbook makes your favorite breakfast sandwhich.

Requirements
------------
TODO: List your cookbook requirements. Be sure to include any requirements this cookbook has on platforms, libraries, other cookbooks, packages, operating systems, etc.

e.g.
#### packages
- `toaster` - app-myphpsite needs toaster to brown your bagel.

Attributes
----------
TODO: List you cookbook attributes here.

e.g.
#### app-myphpsite::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['app-myphpsite']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
#### app-myphpsite::default
TODO: Write usage instructions for each cookbook.

e.g.
Just include `app-myphpsite` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[app-myphpsite]"
  ]
}
```

Contributing
------------
TODO: (optional) If this is a public cookbook, detail the process for contributing. If this is a private cookbook, remove this section.

e.g.
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: TODO: List authors
