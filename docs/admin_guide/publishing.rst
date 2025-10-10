Publishing
==========

What is content?
----------------

The information on a Tripal site is categorized into different :ref:`content types <site-building-tripal-content-types>`.
Examples are Organism, Publication, Project, or Analysis. Additional
content types can be added by another module, or created by a site administrator.

A single record for each of these content types is displayed on the site by an *entity*,
you can think of an entity as "the page".
On each entity you will have multiple *fields*. Each field will present a particular type of information,
such as the tile, or a description.
Fields may contain a single record or multiple records.
A field for a particular entity may also contain no records,
in which case, we typically do not show the field on the entity page.

As an example, this is a **project** entity page, and it is displaying three fields:
title, description, and a link to a related publication.

  .. image:: publishing.1.project_entity_example.png
        :width: 915
        :alt: Example of a project entity page showing title, description, and publication fields

What does publishing mean?
--------------------------

Biological data on a Tripal site is usually stored in the database in the :ref:`Chado schema <GMOD Chado Schema Integration>`.
Publishing refers to the process where this information is made visible to site visitors.
During the process of publishing some particular content type, an entity is created for each corresponding record in the database,
and all fields that are present on each entity are populated with information from the database.

.. note::

  Publishing or unpublishing only affects what content is visible on the web site.
  It does not affect the records stored in the underlying Chado database.

Publishing through the user interface
-------------------------------------

To publish through the user interface, go to

**Tripal** → **Content** → **+Publish Tripal Content**

and select the content type you wish to publish.

You will want to have **Republish Existing Content** active if you have changed the entity title
format, or added any fields to the content type.
In other cases it can be turned off, which may reduce the time required to run the publish job.

The migration file option is used only when migrating a Tripal 3 site.
For more information on how this option works, see :ref:`Migrating Chado <Migrating Chado>`.

.. tip::

  If for some reason you run out of available memory when publishing, you can reduce the batch size and try again.

Publishing with a drush command
-------------------------------

You can publish a content type with a simple drush command.
For example, to publish the **Project** content type:

  .. code-block:: shell

    drush trp-chado-pub project

or to republish

  .. code-block:: shell

    drush trp-chado-pub project --republish

Other drush publish options can be listed with:

  .. code-block:: shell

    drush trp-chado-pub --help

Unpublishing
------------

When Chado records are updated or removed, published content may no longer be synchronized with the contents of the Chado database.

If some records that are shown in fields were updated or removed, the republish option of publish will synchronize them.

If some records that define an entity were deleted, these are termed **orphaned** entities.

They can be selectively unpublished without danger of removing valid records. Go to 

**Tripal** → **Content** → **+Unpublish Tripal Content**

and by leaving the **Only unpublish orphaned content** option checked, existing content still
present in the Chado database will not be affected, only orphaned content will be unpublished.

Limiting publishing when there are too many records
---------------------------------------------------

Because a single field can refer to multiple records of the same type, a mechanism exists
to limit publishing when there are too many records for the web site to display.
For example, a **Genome Annotation** entity may have annotated all genes in a genome,
which could easily be 30,000 genes or more. Displaying this many records in a field is
impossible, so the publish function will limit how many records can be published.
This limit is configurable.

Publish global limit
^^^^^^^^^^^^^^^^^^^^

Access the global limit at

**Tripal** → **Configuration** → **Tripal Entity Settings**

There you will find these options that can be configured:

  .. image:: publishing.2.publishing_options.png
        :width: 633
        :alt: Publishing options form: "Maximum number of linked records to publish" and "Inhibit publish when many records are present"

The second option exists for the case where you prefer to publish no records when the limit is exceeded.
For the 30,000 gene example, you may prefer to not publish a subset, and provide some other mechanism on your site for accessing the gene records.

Publish limit for individual fields
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If you wish to override this global limit for any particular field, you can do so.
Go to

**Tripal** → **Page Structure**

 * For the content type of interest, select **Manage Fields**.

 * For the field of interest, select **Edit**.

 * Change the cardinality from:

  .. image:: publishing.3.cardinality_unlimited.png
        :width: 278
        :alt: Field cardinality shown when set to unlimited

to whatever value you desire, for example 50:

  .. image:: publishing.4.cardinality_50.png
        :width: 266
        :alt: Field cardinality shown when set to 50
