<img src="./5133_-_Delivery_via_Shipping-512.png" width="45%"/>

# not-docker-compose

<b>not-docker-compose</b> allows you to collectivelly or individually manage all aspects of a docker environment, such as containers, networks, images, swarms etc.

<b>not-docker-compose</b>, is a solution, that - big shock coming up! -:
- respects all unix practices and conventions
- is written in plain old bash - <b>NO</b> requirements - <b>100%</b> compatibility
- works with both simple text files, as well as JSON (requires jq) 

:warning: <b>please use bash version > 4</b>

## General Info

:information_source:Commands expect local config file to be named "Composefile" or "composefile".  
If you wish to specify another file as input use the "-f/--file" parameter. 

App configuration is stored under <b>etc/not-docker-compose/apps/\*app_name*</b> .  
You can opt out, and only use local config file (not recommended!) by adding #nostore to your config file!  
Active configurations are defined, using symbolic links, under <b>etc/not-docker-compose/enabled</b> and can be managed using:

```bash
 not-docker-compose enable/disable <app_name>
```

All applications that require timing operations, like starting them on boot, or within a specific timeframe each day, will be forcefully stored even if the "nostore" flag is set.
## config commands

```bash
not-docker-compose config <command> <parameters>;

e.g. not-docker-composer config init --file ./my_config_file
```

> <b>init</b> - initialize config of your applications. If preexisting config is found it will be overwritten (you will be prompted)

> <b>update</b> - will compare config files and append/remove changes (to remove or append individuall properties of apps see "app" section)

## app commands


### top level commands concerning the app as a whole:
```bash
not-docker-compose <app-name> <command> <parameters>;

e.g. no-docker-compose demo_app reset --force;
```

> <b>init</b> - Start the application. This will start all the containers, networks and all other entities required by the application configuration.

> <b>restart</b> - Restart the application, applying any new config changes. Docker entities will remain intact.

> <b>reset</b> - Hard reset the application. This will remove the docker entities and recreate them. Docker conflicts can be overriden using --force.

### individual enityties control commands:
```bash
not-docker-compose <app-name> <entity> <parameter> <value>
```

Configure specific option in an entity app config. For example:

```bash
not-docker-compose demo-app my_entity ip 10.0.0.23
```

will change demo_app->my_entities ip address to 10.0.0.23.
The parameter can be any valid configuration field. For more info please read CONFIGURE.md.
