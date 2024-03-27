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

   And restart if requested.

2. Install PHP

      .. code-block:: shell

        sudo apt-get install php-dom php-gd php-curl php-cli
        php --version

3. Install Apache2 web server. Note the PHP version from step 2 above, and adjust the version of PHP here if necessary.

      .. code-block:: shell

        sudo apt-get install apache2 libapache2-mod-php
        sudo a2enmod rewrite php8.1
        sudo systemctl restart apache2

   At this point, you should be able to open a browser on your installation system and view the Apache2 Default Page at http://localhost

    .. image:: traditional.prereq.apache.jpg
        :width: 318
        :alt: Installation successful, Apache2 Default Page.

4. Install Composer

      .. code-block:: shell

        sudo apt-get install composer

5. Install PostgreSQL database engine

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

Install Drupal
--------------

1. Install Drupal using Composer. Composer is now the recommended way to install and manage Drupal, extension modules, and other dependencies. Detailed information can be found on Drupal's documentation: `Using composer to install Drupal and manage dependencies <https://www.drupal.org/docs/develop/using-composer/using-composer-to-install-drupal-and-manage-dependencies>`__.

    A. Navigate to your webserver's root directory and prepare a directory. You may not have permission to create the directory here, so set it up first using sudo

      .. code-block:: shell

        cd /var/www
        sudo mkdir tripal4
        sudo chown $USER:$USER tripal4
    
    B. Run the composer command to install a fresh copy of Drupal 10 into the ``tripal4`` directory:
    
      .. code-block:: shell
      
        composer create-project drupal/recommended-project /var/www/tripal4

      (If you are presented with this question, you can respond with a `y`:
      `Do you want to remove the existing VCS (.git, .svn..) history? [Y,n]?`)

      This should leave you with a ``tripal4`` directory that looks something like this:

      .. code-block:: shell

        tripal4
        ├── composer.json
        ├── composer.lock
        ├── vendor
        └── web
      
      The ``vendor`` directory is where many of the dependencies like drush (see below) are installed.
      
      The ``web`` directory is the actual webroot for Drupal. This should be the directory that is served by your webserver. **The two composer files and the** ``vendor`` **directory should not be publicly accessible.**

2. Install Drush and other required modules, also with composer, ensuring that you are within your new ``tripal4`` directory:

    .. code-block:: shell

      cd /var/www/tripal4/
      composer require drush/drush drupal/field_group drupal/field_group_table

3. Drupal may complain about permissions on certain files, as well as generating a configuration file from the template provided by Drupal. The files in question must be readable and writable by the webserver's user, as well as yourself. If you're using Apache, this is typically ``www-data`` and for Nginx, it is commonly ``nginx``. Read more about Drupal's requirements here: `Administering a Drupal site - security in Drupal <https://www.drupal.org/docs/administering-a-drupal-site/security-in-drupal/securing-file-permissions-and-ownership>`__, or run the following commands to satisfy them:

    .. code-block:: shell

      # Make sure you are in the web root:
      cd /var/www/tripal4/web

      # Create the files directory:
      mkdir sites/default/files

      # Copy Drupal's configuration template:
      cp sites/default/default.settings.php sites/default/settings.php

      # Set permissions, assuming www-data is your web user (Apache). If
      # necessary, you can determine the Apache username as follows:
      apachectl -S | grep User
      # example output is  User: name="www-data" id=33 not_used

      # Using the user name `www-data` or whatever it may be, change ownership as follows:
      sudo chown www-data:$USER sites/default/files
      sudo chown www-data:$USER sites/default/settings.php

4. Configure Apache to allow access to our install location ``/var/www/tripal4`` so that it will show up as ``http://localhost:/tripal4``. Use your preferred editor and, with sudo, edit ``/etc/apache2/sites-available/000-default.conf`` and make the following additions somewhere inside the ``<VirtualHost *:80>`` section.

    .. code::

      Alias /tripal4 "/var/www/tripal4/web"

      <Directory /var/www/tripal4/web>
         AllowOverride All
      </Directory>

    After saving these changes, restart Apache

    .. code-block:: shell

      sudo systemctl restart apache2

5. Navigate to your new site in your browser: ``<siteaddress.com>/tripal4/core/install.php`` and follow the instructions for setting up a Drupal site. The first page you should appear similar to this:
    
    .. image:: traditional.1.language.jpg
        :width: 500
        :alt: Drupal Installation, Step 1, Language.

    Select your preferred language and continue.

6. For the installation profile select **Standard**, and continue.

    .. image:: traditional.2.profile.jpg
        :width: 600
        :alt: Drupal Installation, Step 2, Profile.

7. If all requirements are met, step 3 should be skipped automatically.

8. In step 4, you will be asked to provide credentials for a database user. Postgres is required for Chado, and therefore it is strongly recommended to use a Postgres database for Tripal.
    Detailed information on creating a Postgres database and user account can be found here: `Getting started - installing Drupal <https://www.drupal.org/docs/getting-started/installing-drupal/create-a-database#create-a-database-using-postgresql>`_.
    For the **Database name** you can use whatever you like. For example ``sitedb``.
    The **Database username** ``drupal`` and **Database password** must be the same as the ones you provided earlier in prerequisite step #5.

    .. image:: traditional.4.database.jpg
        :width: 600
        :alt: Drupal Installation, Step 4, Database Configuration.

9. For step 5, installation of Drupal should begin, with progress shown similar to this.

    .. image:: traditional.5.install.jpg
        :width: 600
        :alt: Drupal Installation, Step 5, Installing Drupal.

10. For step 6, you will need to configure your site. An example is presented below, enter appropriate information for your site.

    .. image:: traditional.6.configure.jpg
        :width: 600
        :alt: Drupal Installation, Step 6, Configure site.

12. You should then see a screen similar to this.

    .. image:: traditional.7.installed.jpg
        :width: 400
        :alt: Drupal Installation, Step 7, Congratulations you installed Drupal.

Install Tripal
--------------

1. We need to first add the Tripal module. There are two options, depending on how you will use your site. If you are installing a production site, or are just trying out Tripal, use method "**A**". If you are a developer you should use method "**B**".

    A. **Production or testing installation.** To just use the most recent **stable** version of tripal install this way:

        .. code-block:: shell

          cd /var/www/tripal4/
          composer require tripal/tripal

      To install the most recent **development** version:

        .. code-block:: shell

          cd /var/www/tripal4/
          composer require tripal/tripal:4.x-dev

      To install a specific released version, find the tag in the `Tripal release page <https://github.com/tripal/tripal/releases>`_, and install it like this:

        .. code-block:: shell

          cd /var/www/tripal4/
          composer require tripal/tripal:4.0-alpha2

    B. **Developer installation.** Clone the Tripal repository in your ``web/modules`` directory.

        Note: Within the ``modules`` directory, you may create your own custom directory to store other extension modules.
    
        .. code-block:: shell
      
          cd /var/www/tripal4/web/modules/
          git clone https://github.com/tripal/tripal.git
          # or if you have a GitHub account configured
          git clone git@github.com:tripal/tripal.git

2. Enable Tripal in your site using the Administration Toolbar: Manage > Extend

    .. image:: traditional.enable-tripal.1.jpg
        :width: 600
        :alt: Enable Tripal, Tripal Chado, Tripal BioDB, and Tripal Layout.

   Select "Continue" to also install "Field Group" and Field Group Table"

    .. image:: traditional.enable-tripal.2.jpg
        :width: 600
        :alt: Also install Field Group and Field Group Table.

   If successful you will see:

    .. image:: traditional.enable-tripal.3.jpg
        :width: 600
        :alt: 6 modules have been enabled: Tripal, Tripal BioDB Task API, Tripal Chado, Tripal Layout, Field Group, Field Group Table.

3. Use Drush to rebuild the cache so that Tripal menu items appear correctly.

    .. code-block:: shell

      /var/www/tripal4/vendor/bin/drush cache-rebuild

Install and Prepare Chado
-------------------------

The site is not quite ready to use yet! The Chado schema must be installed and the site must be prepared to use the installation.

1. On your site, navigate to **Tripal → Data Storage → Chado → Install Chado**
    The page should warn you that Chado is not installed. Use this form to install it. If you wish, you can provide a custom name to your Chado schema:

    .. image:: traditional.4.chado_install.png
      :width: 600
      :alt: Install Chado, optionally provide custom schema name.

2. Click "Install Chado 1.3". You will be prompted to use Drush to trigger the installation of Chado. This must be done on the command line:

    .. code-block:: shell

      /var/www/tripal4/vendor/bin/drush trp-run-jobs --username=drupaladmin --root=/var/www/tripal4/web

3. Once Chado is installed, the site must be further prepared. Navigate to **Tripal → Data Storage → Chado → Prepare Chado**

    .. image:: traditional.5.chado_prepare.png
      :width: 600
      :alt: Prepare the site to use Chado.

4. Click "Prepare this site", and like before, run the supplied Drush command:

    .. code-block:: shell

      /var/www/tripal4/vendor/bin/drush trp-run-jobs --username=drupaladmin --root=/var/www/tripal4/web

Congratulations, you now have a freshly installed Tripal 4 site with Chado as the storage back end. The next step is :doc:`Building your Site <../sitebuilding_guide>`
