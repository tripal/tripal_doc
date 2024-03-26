
Setup Tripal Content Types
============================

When you first install Tripal, you do not yet have any content types created. This is to provide you with flexibility to only add the content types you need for your data.

For a site containing genome assemblies, genes and associated content, you will want to import the *Genomic* content type collections. This is done by navigating to **Admin > Tripal > Page Structure** and then clicking "Import type collection" button. You want to select **Genomic Content Types (Chado)** and click on **Import**

.. note::
  We expect in this tutorial that you already have the "General" content types for Tripal. If you don't have a number of content types already listed that say "General" in the first column when you go to the Page Structure listing then you will also want to select General in the following form.

.. image:: import_tripal_collection.png

Now run the submitted Tripal job from command line as follows if Drupal/Tripal is running as a web application:

::

  drush trp-run-jobs --username=drupaladmin --root=/var/www/drupal/web


If Tripal is running from a docker container named $cntr_name, run:

::

  docker exec -it $cntr_name drush trp-run-jobs --username=drupaladmin --root=/var/www/drupal/web

You will see the following output:

::

  2024-02-14 21:34:50
  Tripal Job Launcher
  Running as user 'drupaladmin'
  -------------------
  2024-02-14 21:34:50: Job ID 1.
  2024-02-14 21:34:50: Calling: import_tripalentitytype_collection(Array)
  [notice] Creating Tripal Content Types from: Genomic Content Types (Chado)
  [notice] Content type, "Gene", created.
  [notice] Content type, "mRNA", created.
  [notice] Content type, "Phylogenetic Tree", created.
  [notice] Content type, "Physical Map", created.
  [notice] Content type, "DNA Library", created.
  [notice] Content type, "Genome Assembly", created.
  [notice] Content type, "Genome Annotation", created.
  [notice] Content type, "Genome Project", created.
  [notice] Attaching fields to Tripal content types from: Chado Fields for Genomic Content Types
  :::
  :::
  :::


Now, when you go to **Admin > Tripal > Page Structure** you will see a Genomic Category that includes Gene and other content required for the Example Genomic site.
