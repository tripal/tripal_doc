Modules
=======

The Drupal ecosystem is very rich when it comes to extension modules that allow a site to provide more functionality with minimal effort. There are many modules available, written by the Drupal community, at `Drupal's Contributed Modules <https://www.drupal.org/docs/extending-drupal/contributed-modules>`__ page.

The Tripal Community has also written a number of useful modules. This list can be found `here <https://tripal.readthedocs.io/en/latest/extensions.html>`__ and is constantly expanding as new modules are written and existing modules are upgraded to work with Drupal 10+.

Drupal Core Modules
-------------------

Drupal comes with many modules installed by default. These can be viewed by navigating to ``/admin/extend`` or by clicking the "Extend" button on the administrator toolbar.

  .. image:: modules.1.drupal_extend.png
        :width: 600
        :alt: Drupal Extension Modules admin page.

On this page, you will be able to see all of the modules that are currently available on your site. As you add new ones, they will appear here. You can enable or disable these modules as well from this page, however some are critical for Drupal to function and cannot be disabled.

Installing Modules
------------------

There are several ways to install new modules. These include:

 - Install them via the **Extend** page, as seen above, by clicking the "+ Add New Module" button.
 - Use Composer (recommended) to make the module a requirement of your site.
 - Manually, either by copying a module or using Git to clone a module's repository into the module directory within your Drupal web directory.

In an effort not to duplicate documentation, it is recommended to refer to `Drupal's own documentation <https://www.drupal.org/node/1897420>`__ on this subject.

For Tripal and other mature modules, using Composer is recommended. However, not all modules have official releases available through Composer and need to be installed manually. The default location in the web directory is the ``modules/`` folder. 

Previously, Drush could be used to download and install new modules. This is no longer the case in Drupal 10. Drush can now only enable or disable modules, or as Drupal 10 refers to these actions, **install** or **uninstall**. The syntax for this is:

  .. code-block:: shell

      # Install
      drush pm:install <module_name>
      # Uninstall
      drush pm:uninstall <module_name>

Uninstalling a module does not remove the module from the filesystem, but rather disables the module.