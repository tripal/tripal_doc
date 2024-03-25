Example Genomic Site Setup
============================

The following tutorial will walk you through creating content and loading genomic data. This is a good introduction to Tripal 4 Content Types and the new Administrative User Interface regardless of whether you intend to store genomic data in your particular Tripal 4 site.

When you first install Tripal, you do not yet have any content types created. This is to provide you with flexibility to only add the content types you need for your data. You will want to add *Genomic* content types to setup a site containing Gene and related content. This is done by navigating to **Admin > Tripal > Page Structure** and then clicking "Import type Collection". You want to select **Genomic Content Types (Chado)** and click on **Import**

.. image:: example_genomic/import_tripal_collection.png

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

.. toctree::
   :maxdepth: 1
   :caption: Table of Contents

   example_genomic/organisms
   example_genomic/analyses
   example_genomic/cross_references
   example_genomic/controlled_vocabs
   example_genomic/genomes_and_genes
