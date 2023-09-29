Creating Content Types
======================

.. note::

  Prior to creating a new content type you should understand the structure of Chado and how others use Chado to store similar types of data.

  As mentioned in the Anatomy of a Tripal Site, all content types are defined by `Controlled Vocabulary (CV) terms <https://en.wikipedia.org/wiki/Controlled_vocabulary>`_.

Find a Controlled Vocabulary (CV) Term
---------------------------------------

Before creating a new content type for your site you must identify a CV term that best matches the content type you would like to create.  CVs are plentiful and at times selection of the correct term from the right vocabulary can be challenging. If there is any doubt about what term to use, then it is best practice to reach out to others to confirm your selection. The Tripal User community is a great place to do this by posting a description of your content type and your proposed term on the `Tripal Issue Queue <https://github.com/tripal/tripal/issues>`_.  Confirming your term with others will also encourage re-use across Tripal sites and improve data exchange capabilities.

The `EBI's Ontology Lookup Service <http://www.ebi.ac.uk/ols/index>`_ is a great place to locate terms from public vocabularies. At this site you can search for terms for your content type.  If you can not find an appropriate term in a public vocabulary or via discussion with others then you create a new **local** term within the **local** vocabulary that comes with Tripal.

.. warning::

  Creation of **local** terms is discouraged but sometimes necessary.  When creating local terms, be careful in your description.

How to Add a CV Term
--------------------
Loading From an OBO File
^^^^^^^^^^^^^^^^^^^^^^^^
Once you've chosen a term to describe your content type, you may need to add the term to Tripal if it is not already present.  Many CVs use the `OBO file format <https://owlcollab.github.io/oboformat/doc/GO.format.obo-1_4.html>`_ to define their terms. If the term belongs to a controlled vocabulary with a file in OBO format then you can load all the terms of the vocabulary using Tripal's OBO Loader at **Tripal → Data Loaders → Chado Vocabularies → Chado OBO Loader**.

.. _adding_a_cvterm:

Manually Adding a Term
^^^^^^^^^^^^^^^^^^^^^^
Alternatively, you can add terms one at a time. To add a single term either from an existing vocabulary or a new local term, navigate to **Tripal → Data Loaders → Chado Vocabularies → Manage Chado CVs** and search to see if the vocabulary already exists. If it does you do not need to add the vocabulary.  If it does not exist, click the **Add Vocabulary** link to add the vocabulary for your term. Then navigate to **Tripal → Data Loaders → Chado Vocabularies → Mange Chado CV Terms** then click the **Add Term link** to add the term.
