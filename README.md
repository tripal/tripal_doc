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

## Contributing

The Tripal documentation is written in **Restructured Text**, compiled with Sphinx, and built/hosted with ReadTheDocs. The docs directory, when compiled, is hosted at https://tripaldoc.readthedocs.io/en/latest.

### Small Minor Changes

For minor changes, you can simply [Edit the file using the Github editor](https://help.github.com/articles/editing-files-in-your-repository/), which will allow you to make a Pull Request. Once approved, your changes will be reflected in the documentation automatically!

### More Extensive Changes

Use our docker image to build the documentation locally. This allows you to make changes locally and then build the documentation to ensure it renders properly before submitting a Pull Request.

If you are part of the github tripal organization then you can clone this repository directly:

```
git clone https://github.com/tripal/tripal_doc
```

Otherwise, you will want to [make a fork](https://docs.github.com/en/get-started/quickstart/fork-a-repo) of our repository and then clone your fork locally.

```
git clone https://github.com/YOUR-GITHUB-USERNAME/tripal_doc
```

Then create a new branch for your changes which matches the github issue you are looking to resolve. For example, if you were working on Issue #123 which was to add documentation for a Tripal Gold medal extension module named tripal_genomic, you would do the following:

```
cd tripal_doc
git checkout -b 123-tripal_genomic_docs
git push --set-upstream origin 123-tripal_genomic_docs
```

Then you would make your changes to the files in the docs folder to add the documentation. Make sure to follow the style conventions described below.

Once you have saved some changes and want to see your locally rendered docs then you run the following command:

```
docker run --rm --volume=`pwd`:/tripal_doc tripalproject/tripaldoc:latest make html
```

If this is the first time you have ever used our image you will see a warning that it was not found locally and then it will download it from docker hub. Then this command creates a container with all the requirements needed and builds the documentation. Since you mounted it to your local directory, the built docs will also be available locally when the container completes and cleans itself up.

To open your recently built docs you will open the index file at `tripal_doc/docs/_build/html/index.html` and navigate through the side menu links to the documentation you added.

Please commit regularily as you work and when your changes are complete and fully committed, push them up to github and submit a pull request to our repository.

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
