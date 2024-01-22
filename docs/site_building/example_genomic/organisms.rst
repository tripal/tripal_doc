Organisms
=========

Before loading our data we must first have an organism to which the data will be associated. Chado v1.3 does not come preloaded with any organisms (although previous version of Chado do). For this tutorial we will import genomic data for Citrus sinesis (sweet orange), so we must first create the organism.

Creating an Organism Page
~~~~~~~~~~~~~~~~~~~~~~~~~

We can add the organism using the Add Tripal Content link in the top administrative menu or from **Content** -> **Add Tripal Content**. The Add Tripal Content page has several content types already available, including the Organism content type.


.. note::

Drupal provides it’s own content types such as Article and Basic Page. These content types are referred to as nodes in Drupal speak. You can add these content types via the Add Content page. Tripal v4 derived content types are separated from these Drupal content types.

.. figure:: add_tripal_content.png

To add a new organism click the **Organism** link and a form will appear with multiple fields. Fill in the fields with these values:

.. csv-table::
  :widths: 10,50
  :header: "Field Name", "Value"

  "Genus", "Citrus"
  "Species", "sinensis"
  "Abbreviation", "C\. sinensis"
  "Common name", "Sweet orange"
  "Description",	"Sweet orange is the No.1 citrus production in the world, accounting for about 70% of the total. Brazil, Flordia (USA), and China are the three largest sweet orange producers. Sweet orange fruits have very tight peel and are classified into the hard-to-peel group. They are often used for juice processing, rather than fresh consumption. Valencia, Navel, Blood, Acidless, and other subtypes are bud mutants of common sweet orange varieties. Sweet orange is considered as an introgression of a natural hybrid of mandarin and pummelo; some estimates shows more mandarin genomic background than pummelo. The genome size is estimated at 380Mb across 9 haploid chromosomes."

Leave all remaining fields empty and save the page. You should now have an organism page that appears as follows:

.. figure:: organism_view.png

Additional Resources:

 `Tripal 3 reference for creating organism <https://tripal.readthedocs.io/en/latest/user_guide/example_genomics/organisms.html>`_

