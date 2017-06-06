# unit-conversion
This repo is for the C1 technical exercise, measurement conversion based on Jess's units.json

##### Prerequisites
- change convert.pl permissions to be executable
- Perl installation including JSON module, such as Vagrant build in https://github.com/companieshouse/ansible-chl

usage example:
```
./convert.pl --type=weight --from=lb --to=kg --v=140
```

#### Notes
- Conversion values based on https://gist.github.com/jessjenkins/c88c6ff207bc43721e729f9c9011aafa
- Other metrics can be add, but values must be in the format, where units are relative to the smallest unit:
```
"name": "dataStorage",
"units": {
    "bit": 1,
    "byte": 8,
    "kilobyte": 8000
}
```