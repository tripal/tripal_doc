Traditional Installation
===========================

These instructions assume that your webserver's root directory is ``/var/www`` and that your site will be installed into a directory called ``tripal4``. Please change these in the commands below if your configuration is different.

They also assume that your system meets all the prerequisites for running a Drupal site. Refer to `the Requirements page <requirements.html>`_ for more information.


Install Prerequisites
-------------------------

1. If you are starting from a clean operating system installation, you will first need to install some needed programs. First make sure the operating system is up to date.

      .. code-block:: shell

        sudo apt-get update
        sudo apt-get dist-upgrade

2. It's probably safest to reboot at this point

3. Install PHP

      .. code-block:: shell

        sudo apt-get install php-dom php-gd php-curl php-cli
        php --version

4. Install Apache2 web server, note the PHP version from step 3 and adjust the version here if necessary

      .. code-block:: shell

        sudo apt-get install apache2 libapache2-mod-php
        sudo a2enmod rewrite php8.1
        sudo systemctl restart apache2

   At this point, you should be able to open a browser on your installation system and view the Apache2 Default Page at http://localhost

5. Install Composer

      .. code-block:: shell

        sudo apt-get install composer

6. Install PostgreSQL database engine

      .. code-block:: shell

        sudo apt-get install postgresql php-pgsql
        sudo su - postgres
        createuser -P drupal

   and supply a password. Now, while we are still the ``postgres`` user, give the drupal user the permissions it will need

      .. code-block:: shell

        psql
        alter role drupal with login replication createdb;
        ALTER DATABASE "template1" SET bytea_output = 'escape';
        \q
        exit

Install Drupal and Tripal
-------------------------

1. Install Drupal using Composer. Composer is now the recommended way to install and manage Drupal, extension modules, and other dependencies. Detailed information can be found on Drupal's documentation: `Using composer to install Drupal and manage dependencies <https://www.drupal.org/docs/develop/using-composer/using-composer-to-install-drupal-and-manage-dependencies>`__.

    a. Navigate to your webserver's root directory and prepare a directory. You may not have permission to create the directory here, so set it up first using sudo

      .. code-block:: shell

        cd /var/www
        sudo mkdir tripal4
        sudo chown $USER:$USER tripal4
    
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

3. Clone the Tripal repository in your ``web/modules`` directory.

    Note: Within the ``modules`` directory, you may create your own custom directory to store other extension modules.
    
    .. code-block:: shell
      
      cd /var/www/tripal4/web/modules/
      git clone https://github.com/tripal/tripal.git

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

5. Configure Apache to allow access to our install location ``/var/www/tripal4`` so that it will show up as ``http://localhost:/tripal4``. Use your preferred editor and, with sudo, edit ``/etc/apache2/sites-available/000-default.conf`` and make the following additions somewhere inside the ``<VirtualHost *:80>`` section.

    .. code::

      Alias /tripal4 "/var/www/tripal4/web"

      <Directory /var/www/tripal4/web>
         AllowOverride All
      </Directory>

    After saving these changes, restart Apache

    .. code-block:: shell

      sudo systemctl restart apache2

6. Navigate to your new site in your browser: ``<siteaddress.com>/tripal4/core/install.php`` and follow the instructions for setting up a Drupal site. You should see a page similar to this:
    
    .. image:: traditional.1.install_step_1.png
        :width: 600
        :alt: Drupal Installation, Step 1.

    In step 4, you will be asked to provide credentials for a database user. Postgres is required for Chado, and therefore it is strongly recommended to use a Postgres database for Tripal.
    Detailed information on creating a Postgres database and user account can be found here: `Getting started - installing Drupal <https://www.drupal.org/docs/getting-started/installing-drupal/create-a-database#create-a-database-using-postgresql>`_.
    For the **Database name** you can use whatever you like. For example ``sitedb``.
    The **Database username** ``drupal`` and **Database password** need to be the same as the ones you provided earlier in prerequisite step #6.

    .. image:: traditional.2.install_step_4.png
        :width: 600
        :alt: Drupal Installation, Step 4

7. Add section here to install field_group and field_group_table?

8. Enable Tripal in your site using the Administration Toolbar: Manage > Extend

    .. image:: traditional.3.enable_tripal.png
        :width: 600
        :alt: Enable Tripal, Tripal Chado, and Tripal BioDB

9. Use Drush to rebuild the cache (``drush cache-rebuild``) so Tripal menu items appear correctly.


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
