Anatomy of a Tripal Site
========================

Content Types
-------------

Tripal sites host data such as organisms, analyses, genes and mRNA, and publications. In Tripal, these are known as **Content Types**. Tripal comes with a number of content types out-of-the-box, but also provides the ability to create custom content types. These content types extend the standard Drupal content types such as Article and Basic Page.

In Tripal, all content types are defined by `Controlled Vocabulary (CV) terms <https://en.wikipedia.org/wiki/Controlled_vocabulary>`_. This has a number of advantages:

1. Facilitates sharing between Tripal sites.
2. Provides a clear indication of what content is available on your site.
3. Makes content creation more intuitive from Tripal v2 (add a "Gene" rather then a "feature").
4. Allows complete customization of what data types your site provides.
5. Integrates tightly with web services allowing Tripal to adhere to RDF specifications

Examples
^^^^^^^^

This is a working list of content types that are currently built-in to Tripal. Some of them are not enabled by default but come in bundled modules.

* General
   * Analysis
   * Contact
   * Organism
   * Project
   * Protocol
   * Publication
   * Study
* Expression
   * Array Design
   * Assay
   * Biological Sample
* Germplasm
   * Breeding Cross
   * Germplasm Accession
   * Germplasm Vareity
   * Recombinant Inbred Line
* Genomic
   * DNA Library
   * Gene
   * Genome Annotation
   * Genome Assembly
   * Genome Project
   * mRNA
   * Phylogenetic Tree
   * Physical Map
* Genetic
   * Genetic Map
   * Genetic Marker
   * Heritable Phenotypic Marker
   * QTL
   * Sequence Variant


Fields
------

Each content type is composed of a number of datapoints, in Tripal these are **Fields**. By default, Tripal uses the Chado database schema to store data, and each field is linked to a specific table and column in Chado.

For example, the Organism content type comes by default with the following fields, and each one represents a property from Chado's definition of an organism:


+--------------------+------------------------------+
|Field Name          |Chado "organism" table column |
+====================+==============================+
|Abbreviation        |abreviation                   |
+--------------------+------------------------------+
|Common Name         |common_name                   |
+--------------------+------------------------------+
|Description         |comment                       |
+--------------------+------------------------------+
|Genus               |genus                         |
+--------------------+------------------------------+
|Infraspecies        |infraspecific_name            |
+--------------------+------------------------------+
|Infraspecific Type  |infraspecific_name            |
+--------------------+------------------------------+
|Species             |species                       |
+--------------------+------------------------------+

Just like with Content Types, each field must also have its own Controlled Vocabulary term associated to it. If we look at the Organism example again, we have the following terms that are drawn from ontologies and their identifier:

+--------------------+------------------------------+--------------------------------------------------------------------------------------+
|Field Name          |Chado "organism" table column |PUMPKIN                                                                               |
+====================+==============================+======================================================================================+
|Abbreviation        |abreviation                   |local:abbreviation                                                                    |
+--------------------+------------------------------+--------------------------------------------------------------------------------------+
|Common Name         |common_name                   |`NCBITaxon:common_name <http://purl.obolibrary.org/obo/ncbitaxon#common_name>`_       |
+--------------------+------------------------------+--------------------------------------------------------------------------------------+
|Description         |comment                       |`schema:description <https://schema.org/description>`_                                |
+--------------------+------------------------------+--------------------------------------------------------------------------------------+
|Genus               |genus                         |`TAXRANK:0000005 <http://purl.obolibrary.org/obo/TAXRANK_0000005>`_                   |
+--------------------+------------------------------+--------------------------------------------------------------------------------------+
|Infraspecies        |infraspecific_name            |`TAXRANK:0000045 <http://purl.obolibrary.org/obo/TAXRANK_0000045>`_                   |
+--------------------+------------------------------+--------------------------------------------------------------------------------------+
|Infraspecific Type  |infraspecific_type            |local:infraspecific_type                                                              |
+--------------------+------------------------------+--------------------------------------------------------------------------------------+
|Species             |species                       |`TAXRANK:0000006 <http://purl.obolibrary.org/obo/TAXRANK_0000006>`_                   | 
+--------------------+------------------------------+--------------------------------------------------------------------------------------+
