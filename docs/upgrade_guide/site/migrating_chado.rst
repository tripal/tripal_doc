Migrating Chado
=================

Migrating your existing Tripal 3 site to Tripal 4 involves copying the data present in Chado to a new site.
The procedure for this is as follows:

1. Use ``pg_dump`` to export your chado data out of your existing Tripal 3 site.
   You will have to substitute your Tripal 3 site's connection information and database name,
   since this varies for different sites depending on how it was originally installed.

.. code-block:: bash

  pg_dump CONNECTION_INFORMATION --schema="chado" \
    --format=plain --no-owner --no-privileges --compress=9 \
    TRIPAL3_DATABASENAME > chado.sql.gz

2. Create a fresh Tripal 4 site.
   Instructions for this can be found on the :ref:`How to Install Tripal` page.
   It is important that you either **skip** the step where you :ref:`Install and Prepare Chado`,
   or if you are using a Docker image and chado is installed automatically,
   you should specify a name for your chado schema that is **different** than your existing
   Tripal 3 site. For example:

   ``--build-arg chadoschema="tempchado"``.

3. `If you are using docker`, copy your Tripal 3 chado database dump to inside your
   Tripal 4 docker container using ``docker cp``, and then obtain a bash shell inside your docker.
   For example, if your container is named "tripal4" you could run

.. code-block:: bash

  docker cp chado.sql.gz tripal4:/var/www/drupal/web/
  docker exec -it tripal4 /bin/bash

4. Upload your Tripal 3 chado database dump to your new Tripal 4 Postgresql database.
   Again, substitute appropriate Tripal 4 connection information.

.. code-block:: bash

  gunzip -c chado.sql.gz | psql CONNECTION_INFORMATION TRIPAL4_DATABASENAME

.. note::

  | If you encounter the error
  | ``ERROR: data type bigint has no default operator class for access method "gist"``
  | then you will need to run this command at a sql prompt **before** uploading your chado database dump:
  | ``sitedb=> CREATE EXTENSION IF NOT EXISTS btree_gist;``

5. Now you need to check that your imported existing chado matches what Tripal 4 expects as far as cvterms go.
   This can be done using the command

   .. code-block:: bash

     drush trp-check-terms --chado_schema=chado

   **It is likely there will be things to fix!**

   The tool can correct some errors automatically, but it is possible that some will need manual correction.

.. tip::

   Run this command to see more options: ``drush trp-check-terms --help``

6. Once that command tells you there are no errors with your cvterm setup, then you can
   prepare your chado instance by going to `TRIPAL4-SITE/admin/tripal/storage/chado/prepare`.

7. Now go into your Tripal 4 site and set the newly imported and prepared chado to be your default chado.

  a. Go to TRIPAL4-WEBSITE/admin/tripal/storage/chado/manager

  b. Click the "Add to Tripal" button

  c. Click the "Set Default" button.

  d. Optional: If you had a temporary Chado schema, you can drop it at this point.

8. We recommend that you reserve existing entity ID numbers, so that you can later generate url aliases that will match your Tripal 3 site. To do so

  a. On your existing **Tripal 3** site, launch a psql command prompt and run this command

  .. code-block::

    sitedb=> SELECT NEXTVAL('tripal_entity_id_seq');

     nextval 
    ---------
      123456  ← make note of this number
    (1 row)

  b. On your new **Tripal 4** site, set it with

  .. code-block::

    sitedb=> ALTER SEQUENCE tripal_entity_id_seq RESTART 123456;  ← substitue the number from step a.

.. note::

  The plan is to add a command in the future that will help pull over url aliases from your Drupal 7 site for existing pages.

9. You can now import content types

  a. Go to Tripal → Page Structure
  b. Click on the "+Import type collection" button
  c. Select the checkboxes on your desired collections and click the "Import" button.
  d. You will then need to run the job. For example:

  .. code-block::

    drush trp-run-jobs --username=drupaladmin --root=/var/www/drupal/web

10. Now find fields so that you can start configuring your content types.

  a. Go to Tripal → Page Structure
  b. For each of the content types, on the right select "Manage Fields"
  c. Click on the "+Check for new fields" button.

11. Publish all of your content types.
    You can now publish your imported chado content for each of the appropriate content types.
    For example, to publish organisms

  a. Go to Tripal → Content → +Publish Tripal Content

  b. Under "Content Type" select "Organism", and then click on the Publish button.

  c. You will then need to run the job. For example:

  .. code-block::

    drush trp-run-jobs --username=drupaladmin --root=/var/www/drupal/web
