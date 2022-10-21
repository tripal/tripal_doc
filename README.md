![alt tag](https://raw.githubusercontent.com/tripal/tripal/7.x-3.x/tripal/theme/images/tripal_logo.png)

# Home of Tripal Documentation

[![Documentation Status](https://readthedocs.org/projects/tripaldoc/badge/?version=latest)](https://tripaldoc.readthedocs.io/en/latest/?badge=latest)

This repository is the official home of [Tripal](https://tripal.info) documentation!  Here Tripal core developers and extension module creators can place documentation for using tripal.

The most recent version of this documentation can be viewed online at https://tripaldoc.readthedocs.io/en/latest/

**NOTE: This repository currently starts with Tripal 4.x documentation. For access to the Tripal 3 documentation, please look within the docs folder of the Tripal 3.x codebase or access it online at https://tripal.readthedocs.io/en/7.x-3.x/**

## Documentation Design

The plan for Tripal 4 documentation is to provide a single resource for Tripal Users and Developers. Rather then documenting Tripal with the assumption you know Drupal, we are going to teach both Drupal/Tripal and provide links to core Drupal documentation for more information. This should make the Tripal 4 documentation an easier resource for PIs to point new developers at.

Idealistic Overview:
1. Install Tripal
2. Building your site: creating vocabularies, configuring pages...
3. Guiding your users: creating content, searching...
4. Site Administration: Importing data, administering users...
5. Extending Tripal
6. Upgrading Tripal
7. How to Contibute (Tripal Community)

Please feel free to create new issues in this repository to provide feedback or suggestions for this design! Also, if there is anything in particular you would like documented which is not currently, please start an issue for it! This helps us be purposeful in our documentation and ensure we are meeting the needs of our community.

## Documentation Style

The Tripal documentation is written in **Restructured Text**, compiled with Sphinx, and built/hosted with ReadTheDocs. The docs directory, when compiled, is hosted at https://tripal.readthedocs.io/en/latest/.

For minor changes, you can simply [Edit the file using the Github editor](https://help.github.com/articles/editing-files-in-your-repository/), which will allow you to make a Pull Request. Once approved, your changes will be reflected in the documentation automatically!

For more extensive changes:

### Install Sphinx

For minor changes, you don’t need to build the documentation! If you want to see how your changes will look on the built site, however, you will need Sphinx installed.

For more information, please see the Sphinx setup guide: http://www.sphinx-doc.org/en/master/usage/quickstart.html

### Building your changes

For more extensive edits, or when contributing new guides, you should build the documentation locally. 

```
git clone https://github.com/tripal/tripal_doc
cd tripal_doc
make html --dir=docs
```

The built site will be in `docs/_build/html/index.html`.

### Tripal conventions

Please follow these guidelines when updating our docs. Let us know if you have any questions or something isn’t clear.

Please place images in the same folder as the guide text file, following the convention `[file_name].[n].[optional description].[extension]`. For example, `configuring_page_display.3.rearrange.png` or `configuring_page_display.1.png` are both located in `docs/user_guide/` and are part of the `configuring_page_display.rst` guide.

We currently use the following syntax:

```rst

Title of File (using title case)
=================================

Introduction text.

Section Title
-------------

We use double backticks to indicate ``inline-code`` including file names, function and method names, paths, etc.

Longer code-blocks should begin with the ``.. code-block:: [type]`` directive and should be indented at least one
level. There should also be a blank line before and after it as shown below.

.. code-block:: sql
  if ($needs_documentation) {
      use $these_guidelines;
      $contribute_docs = $appreciated;
  }

Section 1.1 Title
^^^^^^^^^^^^^^^^^

The use of appropriate sections makes reading documentation and later specific details easier. Sub sections such
as this one will be hidden unless the main section is already selected.
```
