
Upgrading a Module
==================

Upgrading a module from Drupal 7 to Drupal 10 and beyond can be accomplished by following the following instructions.

Github Recommendation
---------------------

The Tripal team recommends creating a new empty branch in your Github or Gitlab repository, generating the template, and then moving over functionality. Rather than creating a new branch and deleting all of your old code, the ``--orphan`` argument can be used to create a fresh branch free of all files and history:

  .. code:: 

    git switch --orphan <new branch>


Adminstrator Permissions
------------------------

By default, using ``drush generate`` will not generate a ``permissions.yml`` file. For Tripal extension modules, it is recommended that modules use the value 'administer tripal' for the administrative routes (discussed below). Exceptions to this recommendation might include situations where you have curators or undergrads performing tasks for this module specifically but not for the entirety of Tripal. In this case, 'administer <module_name>' would be more appropriate. In this case, you would want to have `drush generate` create the `permissions.yml` file.

Generate a Module Skeleton
--------------------------

For this tutorial we will be using the `Tripal Docker <https://tripaldoc.readthedocs.io/en/latest/install/docker.html>`_ to quickly build an instance of Drupal 10 and Tripal 4, including Drush. The following instructions assume you have already created a new empty branch for your existing module. If that is not the case, the instructions will also work in a newly-created directory, such as ``potato_module``:

  .. code-block:: shell

    mkdir potato_module
    cd potato_module

Then start up Tripal Docker in such a way to mount your local potato_module directory inside a newly created container:

  .. code-block:: shell

    docker run --publish=9000:80 --name=potatodev -tid --volume=`pwd`:/var/www/drupal/web/modules/potato_module tripalproject/tripaldocker:latest

Now you have a fully installed Tripal development environment where you can start working on the potato module in your local folder and all the changes will automatically be reflected in the Tripal site (i.e. docker container). This process is the same no matter where you are at in development of your Tripal 4 extension module (obviously using a git repo clone in later stages as compared to the empty directory above).

Now we are going to generate code for a Drupal module based on templates using Drush!

To use drush we are going to need to be inside the docker container since that is where it is installed. To do that we do the docker equivalent of ssh-ing into a server, which is to use docker exec to open an interactive terminal inside the container:

  .. code-block:: shell
    
    docker exec -it potatodev bash

Now you can run any commands just as if you had installed everything locally!

To generate a new module template, issue the following command. You'll be prompted several times for different options:

  .. code-block:: shell

    root@0335ed1a94c3:/var/www/drupal9/web# drush generate module

    Welcome to module generator!
    ––––––––––––––––––––––––––––––

    Module name [Web]:
    ➤ My Potato Module

    Module machine name [my_potato_module]:
    ➤ potato_module

    Module description [Provides additional functionality for the site.]:
    ➤ This module will integrate beautiful potato pictures in a Drupal site.

    Package [Custom]:
    ➤ Tripal Extensions

    Dependencies (comma separated):
    ➤ tripal, tripal_chado

    Would you like to create module file? [No]:
    ➤ Yes

    Would you like to create install file? [No]:
    ➤ Yes

    Would you like to create libraries.yml file? [No]:
    ➤ Yes

    Would you like to create permissions.yml file? [No]:
    ➤ Yes

    Would you like to create event subscriber? [No]:
    ➤ 

    Would you like to create block plugin? [No]:
    ➤ 

    Would you like to create a controller? [No]:
    ➤ Yes

    Would you like to create settings form? [No]:
    ➤ Yes

    The following directories and files have been created or updated:
    –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    • /var/www/drupal9/web/modules/potato_module/potato_module.info.yml
    • /var/www/drupal9/web/modules/potato_module/potato_module.install
    • /var/www/drupal9/web/modules/potato_module/potato_module.libraries.yml
    • /var/www/drupal9/web/modules/potato_module/potato_module.links.menu.yml
    • /var/www/drupal9/web/modules/potato_module/potato_module.module
    • /var/www/drupal9/web/modules/potato_module/potato_module.permissions.yml
    • /var/www/drupal9/web/modules/potato_module/potato_module.routing.yml
    • /var/www/drupal9/web/modules/potato_module/config/schema/potato_module.schema.yml
    • /var/www/drupal9/web/modules/potato_module/src/Controller/PotatoModuleController.php
    • /var/www/drupal9/web/modules/potato_module/src/Form/SettingsForm.php

And now you will have the files above both inside your container and locally!

This means you can open your editor of choice and edit the generated files added to your local potato_module directory to make it more specific to your extension module. You can also use the other generators we saw above to continually add to this module!


