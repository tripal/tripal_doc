Migrating Chado
=================

Migrating your existing Tripal 3 site to Tripal 4 involves copying the data present in Chado to a new site.
The procedure for this is as follows:

1. Use ``pg_dump`` to export your chado data out of your existing Tripal 3 site.
   You will have to substitute your site's connection information and database name,
   since this varies for different sites depending on how it was originally installed.

.. code-block:: bash

  pg_dump CONNECTION_INFORMATION --schema="chado" \
    --format=plain --no-owner --no-privileges --compress=9 \
    DATABASENAME > chado.sql.gz

2. Create a fresh Tripal 4 site.
   Instructions for this can be found on the :ref:`How to Install Tripal` page.
   It is important that you either **skip** the step where you :ref:`Install and Prepare Chado`,
   or if you are using a Docker image and chado is installed automatically,
   you should specify a name for your chado schema that is **different** than your existing
   Tripal 3 site, for example ``tempchado`` or ``teacup``.

3. Upload your Tripal 3 chado database dump to your new Tripal 4 site.
   Again, substitute appropriate connection information.

.. code-block:: bash

  gunzip -c chado.sql.gz | psql CONNECTION_INFORMATION TRIPAL4_DATABASE

4. The next step is to check that your imported existing chado matches what Tripal 4 expects as far as cvterms go.
   This can be done using the command `drush trp-check-terms --chado_schema=chado`

5. Once that command tells you there are no errors with your cvterm setup, then you can
   prepare your chado instance by going to TRIPAL4-SITE/admin/tripal/storage/chado/prepare.

6. Now go into your Tripal 4 site and set the newly imported and prepared chado to be your default chado.

  a. Go to http://TRIPAL4-WEBSITE/admin/tripal/storage/chado/manager

  b. Click the "Add to Tripal" button

  c. Click the "Set Default" button.

  d. If you had a temporary Chado schema, you can drop it at this point.

7. We recommend that you reserve existing entity ID numbers, so that you can later generate url aliases that will match your Tripal 3 site. To do so

  a. On your existing **Tripal 3** site, launch a psql command prompt and run this command

  .. code-block:: sql

    SELECT NEXTVAL('tripal_entity_id_seq');

     nextval 
    ---------
      123456
    (1 row)

  b. On your **Tripal 4** site, set it with

  .. code-block:: sql

    ALTER SEQUENCE tripal_entity_id_seq RESTART 123456;

8. You can now import content types and find fields so that you can start configuring your content types.

9. Publish all of your content.

.. notice::
  The plan is to add a command in the future that will help pull over url aliases from your Drupal 7 site for existing pages.

