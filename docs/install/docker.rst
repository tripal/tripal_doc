Tripal Docker
================

Tripal Docker is currently focused on Development, Debugging, and Unit Testing. There will be a production focused Tripal Docker soon.

Software Stack
--------------

Currently we have the following installed:
 - Debian Bullseye(11)
 - PHP 8.2.17 with extensions needed for Drupal (Memory limit 1028M)
 - Apache 2.4.56
 - PostgreSQL 16.2 (Debian 16.2-1.pgdg110+2)
 - Composer 2.7.2
 - Drush 12.5.1.0
 - Drupal 10.2.5-dev downloaded using composer (or as specified by drupalversion argument).
 - Xdebug 3.2.1

Quickstart
----------

1. Run the image in the background mapping its web server to your port 9000.

    a) Stand-alone container for testing or demonstration.

    .. code::

      docker run --publish=9000:80 --name=t4 -tid tripalproject/tripaldocker:latest

    b) Development container with current directory mounted within the container for easy edits. Change my_module with the name of yours.

    .. code::

      docker run --publish=9000:80 --name=t4 -tid --volume=$(pwd):/var/www/drupal/web/modules/contrib/my_module tripalproject/tripaldocker:latest

2. Start the PostgreSQL database.

.. code::

  docker exec t4 service postgresql start


Development Site Information:
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

+-------------------------+-----------------------+
| URL                     | http://localhost:9000 |
+-------------------------+-----------------------+
| Administrative User     | drupaladmin           |
+-------------------------+-----------------------+
| Administrative Password | some_admin_password   |
+-------------------------+-----------------------+


Usage
----------

 - Run Drupal Core PHP Unit Tests:

   .. code::

    docker exec --workdir=/var/www/drupal/web/modules/contrib/tripal t4 phpunit

 - Open PSQL to query the database on the command line. The password is docker.

   .. code::

    docker exec -it t4 psql --user docker sitedb

 - Run Drush to generate code for your module!

   .. code::

    docker exec t4 drush generate module

 - Run Drush to rebuild the cache

   .. code::

    docker exec t4 drush cr

 - Get version information:

   .. code::

    docker exec t4 drush status
    docker exec t4 php -v
    docker exec t4 psql --version
    docker exec t4 apache2 -v

 - Run Composer to upgrade Drupal

   .. code::

    docker exec t4 composer up

Detailed Setup for Core Development
------------------------------------

If you want to contribut to Tripal development, you will likely want to create a create a branch to work on and create a Docker using this branch, or on another contributor's branch. For instructions on how to do this, see the section [link](#creating-a-docker-for-testing)

Troubleshooting
---------------

The provided host name is not valid for this server.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
On my web browser, I got the message "The provided host name is not valid for this server".

**Solution:** It is most likely because you tried to access the site through a URL different from ``localhost`` or ``127.0.0.1``. For instance, if you run docker on a server and want to access your d8t4 site through that server name, you will have to edit the settings.php file inside the docker (at the time writing this, it would be every time you (re)start the docker) and change the last line containing the parameter ``$settings[trusted_host_patterns]``. This file by default is read-only, so you will first need to change permissions to allow editing:

.. code::

  docker exec -it t4 chmod +w /var/www/drupal/web/sites/default/settings.php
  docker exec -it t4 vi /var/www/drupal/web/sites/default/settings.php

For instance, if your server name is ``www.yourservername.org``:

.. code::

  $settings[trusted_host_patterns] = [ '^localhost$', '^127\.0\.0\.1$', '^www\.yourservername\.org$', ];

Not seeing recent functionality or fixes.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

As Tripal 4 is currently under rapid development, this could be due to not using the most up to date docker image available. The following instructions can be used to confirm you are using the most recent image.

.. code-block:: bash

  docker rm --force t4
  docker rmi tripalproject/tripaldocker:latest
  docker pull tripalproject/tripaldocker:latest

At this point, you can follow up with the appropriate ``docker run`` command. If your run command mounts the current directory through the ``--volume`` parameter then make sure you are in a copy of the t4 repository on the main branch with the most recent changes pulled.

Debugging
---------

Xdebug: Overview
^^^^^^^^^^^^^^^^
There is an optional Xdebug configuration available for use in debugging Tripal 4.
It is disabled by default. Currently, the Docker ships with three modes available:

`Develop <https://xdebug.org/docs/develop>`_
  Adds developer aids to provide "better error messages and obtain more information from PHP's built-in functions".

`Debug <https://xdebug.org/docs/step_debug>`_
  Adds the ability to interactively walk through the code.

`Profile <https://xdebug.org/docs/profiler>`_
  Adds the ability to "find bottlenecks in your script and visualize those with an external tool".

To enable Xdebug, issue the following command:

.. code::

  docker exec --workdir=/var/www/drupal/web/modules/contrib/tripal t4 xdebug_toggle.sh

This will toggle the Xdebug configuration file and restart Apache. You should use this command to disable Xdebug if it is enabled prior to running PHPUnit Tests as it seriously impacts test run duration (approximately 8 times longer).


There is an Xdebug extension available for most modern browsers that will let you dynamically trigger different debugging modes. For instance, profiling should only be used when you want to generate profiling data, as this can be quite compute intensive and may generate large files for a single page load.
The extension places an interactive Xdebug icon in the URL bar where you can select which mode you'd like to trigger.

Xdebug: Step debugging
^^^^^^^^^^^^^^^^^^^^^^

Step debugging occurs in your IDE, such as Netbeans, PhpStorm, or Visual Studio Code.
There will typically already be a debugging functionality built-in to these IDEs, or they can be installed with an extension.
Visual Studio Code, for example, has a suitable debugging suite by default.
This documentation will cover Visual Studio Code, but the configuration options should be similar in other IDEs.

The debugging functionality can be found in VS Code on the sidebar, the icon looks like a bug and a triangle.
A new configuration should be made using PHP. The following options can be used for basic interaction with Xdebug:
.. code::

  {
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Listen for Xdebug",
            "type": "php",
            "request": "launch",
            "port": 9003,
            "pathMappings": { "/var/www/drupal/web/modules/contrib/tripal": "~/Dockers/t4" }
        }
    ]
  }

The important parameter here is `pathMappings` which will allow Xdebug and your IDE know which paths on the host and in the Docker VM coorespond to eachother.
The first path listed is the one within the Docker and should point to the Tripal directory. The seocnd path is the one on your local host machine where you
installed the repo and built the Docker image. If you followed the instructions above, this should be in your user folder under `~/Dockers/t4`.

9003 is the default port and should only be changed if 9003 is already in use on your host system.

With this configuration saved, the Play button can be pressed to enable this configuration and have your IDE listen for incoming connections from the Xdebug PHP extension.

More info can be found for VS Code's step debugging facility in `VS Code's documentation <https://code.visualstudio.com/docs/editor/debugging>`_.

Xdebug: Profiling
^^^^^^^^^^^^^^^^^

Profiling the code execution can be useful to detect if certain functions are acting as bottlenecks or if functions are being called too many times, such as in an unintended loop.
The default configuration, when profiling is enabled by selecting it in the Xdebug browser extension, will generate output files in the specified directory.

To view these files, we recommend using Webgrind. It can be launched as a separate Docker image using the following command:

.. code::

  docker run --rm -v ~/Dockers/t4/tripaldocker/xdebug_output:/tmp -v ~/Dockers/t4:/host -p 8081:80 jokkedk/webgrind:latest

You may need to adjust the paths given in the command above, similar to when setting up the pathMappings for step debugging earlier.
