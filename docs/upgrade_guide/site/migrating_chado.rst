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
   Tripal 3 site, for example ``--build-arg chadoschema="tempchado"``.

3. Upload your Tripal 3 chado database dump to your new Tripal 4 site.
   Again, substitute appropriate Tripal 4 connection information.

.. code-block:: bash

  gunzip -c chado.sql.gz | psql CONNECTION_INFORMATION TRIPAL4_DATABASENAME

.. note::
  | If you encounter the error
  | ``ERROR: data type bigint has no default operator class for access method "gist"``
  | then you will need to run this command at a sql prompt **before** uploading your chado database dump:
  | ``sitedb=> CREATE EXTENSION IF NOT EXISTS btree_gist;``

4. Now you need to check that your imported existing chado matches what Tripal 4 expects as far as cvterms go.
   This can be done using the command

.. code-block:: bash

  drush trp-check-terms --chado_schema=chado

5. Once that command tells you there are no errors with your cvterm setup, then you can
   prepare your chado instance by going to TRIPAL4-SITE/admin/tripal/storage/chado/prepare.

6. Now go into your Tripal 4 site and set the newly imported and prepared chado to be your default chado.

  a. Go to TRIPAL4-WEBSITE/admin/tripal/storage/chado/manager

  b. Click the "Add to Tripal" button

  c. Click the "Set Default" button.

  d. If you had a temporary Chado schema, you can drop it at this point.

7. We recommend that you reserve existing entity ID numbers, so that you can later generate url aliases that will match your Tripal 3 site. To do so

  a. On your existing **Tripal 3** site, launch a psql command prompt and run this command

  .. code-block:: sql

    sitedb=> SELECT NEXTVAL('tripal_entity_id_seq');

     nextval 
    ---------
      123456  ← make note of this number
    (1 row)

  b. On your **Tripal 4** site, set it with

  .. code-block:: sql

    sitedb=> ALTER SEQUENCE tripal_entity_id_seq RESTART 123456;  ← substitue the number from step a.

8. You can now import content types and find fields so that you can start configuring your content types.

9. Publish all of your content types.

.. notice::
  The plan is to add a command in the future that will help pull over url aliases from your Drupal 7 site for existing pages.

