
Fields
=========

For fields there are three main components to test:

1. That the data is created, loaded and updated appropriately from the backend data storage.
2. That the field classes match what is expected by the API and return the appropriate values.
3. That the edit form and page display perform as expected when rendered.

The first two lend themselves really well to kernel testing which is much faster than functional testing as it creates a more focused and streamlined test environment. That said, kernel tests are not run with a fully functioning Drupal site, but rather only specific functionality indicated by the test setUp is available. However, the third testing goal needs to interact with a rendered Tripal Content page and thus a functional test is required.

For more information on how to test each of the above goals, see the following tutorials:

.. toctree::
   :maxdepth: 2

   fields/chadoStorage

