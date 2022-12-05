
Automated Testing
===================

Drupal integrates with `PHPUnit <https://phpunit.readthedocs.io>`_ for automated testing, with the `official testing documentation available on Drupal.org <https://www.drupal.org/docs/automated-testing/phpunit-in-drupal>`_.

Here we are going to focus specifically on Tripal including details on the Tripal testing suite, the new base classes provided which extend core Drupal's classes, and how to write your own tests with Tripal specific examples.

.. note::

  Tripal 4 is being developed with automated testing as it is upgraded. This greatly improves the stability of our software and our ability to fix any bugs. We highly recommend developing automated testing alongside any extension modules you create!

.. toctree::
   :maxdepth: 1
   :caption: Contents:

   testing/running_tests
   testing/TripalTestSuite
   testing/additional_resources
