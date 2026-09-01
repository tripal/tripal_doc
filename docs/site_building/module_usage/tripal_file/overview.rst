Tripal File Overview
======================

The Tripal File module supports association of data files with content in a Chado database
and integrates those associations with content types on a Tripal website.

.. image:: https://upload.wikimedia.org/wikipedia/commons/thumb/a/aa/FAIR_data_principles.jpg/320px-FAIR_data_principles.jpg
      :alt: The 'FAIR' logo, spelled out is Findable, Accessible, Interoperable, Reusable

These associations are meant to support
`FAIR data principles <https://www.go-fair.org/fair-principles/>`_
by integrating with Tripal content and web services such that:

- Files are findable and accessible via Tripal's content web services.
- Metadata about files use globally unique controlled vocabularies. These metadata can be assigned as properties of each file.
- License and usage details can be assigned to each file.

This module provides two new content types for Tripal sites: **File** and **License**.

Initial development of the Tripal File module was funded by the
`National Science Foundation award #1659300 <https://nsf.gov/awardsearch/showAward?AWD_ID=1659300>`_
and the `National Research Support Program (NRSP) 10 project <https://www.nrsp10.org/>`_
and the McIntire-Stennis project 1019284.
