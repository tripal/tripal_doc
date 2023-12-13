Traditional Installation
===========================

These instructions assume that your webserver's root directory is ``/var/www`` and that your site will be installed into a directory called ``tripal4``. Please change these in the commands below if your configuration is different.

They also assume that your system meets all the prerequisites for running a Drupal site. Refer to `the Requirements page <requirements.html>`_ for more information.


Install Drupal and Tripal
-------------------------

1. Install Drupal using Composer. Composer is now the recommended way to install and manage Drupal, extension modules, and other dependencies. Detailed information can be found on Drupal's documentation: `Using composer to install Drupal and manage dependencies <https://www.drupal.org/docs/develop/using-composer/using-composer-to-install-drupal-and-manage-dependencies>`__.

    a. Navigate to your webserver's root directory:

      .. code-block:: shell

        cd /var/www
    
    b. Run the composer command to install a fresh copy of Drupal 10 into the ``tripal4`` directory:
    
      .. code-block:: shell
      
        composer create-project drupal/recommended-project tripal4

      This should leave you with a ``tripal4`` directory that looks something like this:

      .. code-block:: shell

        tripal4
        ├── composer.json
        ├── composer.lock
        ├── vendor
        └── web
      
      The ``vendor`` directory is where many of the dependencies like drush (see below) are installed.
      
      The ``web`` directory is the actual webroot for Drupal. This should be the directory that is served by your webserver. **The two composer files and the** ``vendor`` **directory should not be publicly accessible.**

2. Install Drush as well, also with composer, ensuring that you are within your new ``tripal4`` directory:

    .. code-block:: shell

      cd /var/www/tripal4/
      composer require drush/drush

3. Use Composer to install Tripal as well, ensuring you are still within the same directory as the step abve.
    
    .. code-block:: shell
      
      composer require tripal/tripal

4. Drupal may complain about permissions on certain files, as well as generating a configuration file from the template provided by Drupal. The files in question must be readable and writable by the webserver's user. If you're using Apache, this is typically ``www-data`` and for Nginx, it is commonly ``nginx``. Read more about Drupal's requirements here: `Administering a Drupal site - security in Drupal <https://www.drupal.org/docs/administering-a-drupal-site/security-in-drupal/securing-file-permissions-and-ownership>`__, or run the following commands to satisfy them:

    .. code-block:: shell

      # Make sure you are in the web root:
      cd /var/www/tripal4/web

      # Create the files directory:
      mkdir sites/default/files

      # Copy Drupal's configuration template:
      cp sites/default/default.settings.php sites/default/settings.php

      # Set permissions, assuming www-data is your web user (Apache):
      sudo chown www-data sites/default/files
      sudo chown www-data sites/default/settings.php


5. Navigate to your new site in your browser: ``<siteaddress.com>/core/install.php`` and follow the instructions for setting up a Drupal site. You should see a page similar to this:
    
    .. image:: traditional.1.install_step_1.png
        :width: 600
        :alt: Drupal Installation, Step 1.

    You will be asked to provide credentials for a database user. Postgres is required for Chado, and therefore it is strongly recommended to use a Postgres database for Tripal.
    Detailed information on creating a Postgres database and user account can be found here: `Getting started - installing Drupal <https://www.drupal.org/docs/getting-started/installing-drupal/create-a-database#create-a-database-using-postgresql>`_.

    .. image:: traditional.2.install_step_4.png
        :width: 600
        :alt: Drupal Installation, Step 4

6. Enable Tripal in your site using the Administration Toolbar > Extend

    .. image:: traditional.3.enable_tripal.png
        :width: 600
        :alt: Enable Tripal, Tripal Chado, and Tripal BioDB

7. Use Drush to rebuild the cache (``drush cache-rebuild``) so Tripal menu items appear correctly.


Install and Prepare Chado
-------------------------

The site is not quite ready to use yet! The Chado schema must be installed and the site must be prepared to use the installation.

1. On your site, navigate to **Tripal →  Data Storage → Chado → Install Chado**
    The page should warn you that Chado is not installed. Use this form to install it. If you wish, you can provide a custom name to your Chado schema:

    .. image:: traditional.4.chado_install.png
      :width: 600
      :alt: Install Chado, optionally provide custom schema name.

2. Click "Install Chado 1.3". You will be prompted to use Drush to trigger the installation of Chado. This must be done on the command line, in the same location where Drupal is installed.

    .. code-block:: shell

      cd /var/www/tripal4/web/
      drush trp-run-jobs --job_id=1 --username=admin --root=/var/www/tripal4/web

3. Once Chado is installed, the site must be further prepared. Navigate to **Tripal → Data Storage → Chado → Prepare Chado**

    .. image:: traditional.5.chado_prepare.png
      :width: 600
      :alt: Prepare the site to use Chado.

4. Click "Prepare this site", and like before, run the supplied Drush command:

    .. code-block:: shell

      cd /var/www/tripal4/web/
      drush trp-run-jobs --job_id=2 --username=admin --root=/var/www/tripal4/web

Congratulations, you now have a freshly installed Tripal 4 site with Chado as the storage back end. The next step is :doc:`Building your Site <../sitebuilding_guide>`
