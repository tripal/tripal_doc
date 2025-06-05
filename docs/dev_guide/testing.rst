
Automated Testing
===================

Tripal 4 is being developed with automated testing as it is upgraded. This greatly improves the stability of our software and our ability to fix any bugs. We highly recommend developing automated testing alongside any extension modules you create! This guide is intended to explain how automated testing is working for Tripal 4 and help you develop similar tests for your extensions.

You can find the tests for any Drupal module in the `tests` directory. Since Tripal core is composed of a number of submodules, you will find our test suite covers a number of directories:

- Tripal Core (`tripal/tests`): these tests are focused on core functionality which is available to all Tripal sites.
- Tripal Chado (`tripal_chado/tests`): here we test all interactions with the Chado database including database management, fields and Chado integration with core APIs such as Tripal DBX.
- Tripal BioDB (`tripal_biodb/tests`): these tests focus on the Tripal BioTask API for managing database focused tasks which can benefit from advanced locking.
- Tripal Layout (`tripal_layout/tests`): here we test the default layouts for Tripal Content forms and view displays.

You will notice that in each of these test directories, there are a number of subdirectories. These are there by Drupal convention.

- fixtures: this is where any SQL files or mock classes should go for setting up your tests.
- src:

    - Unit: PHPUnit-based tests with minimal dependencies. These should focus on testing specific methods using mock objects and should not require a fully bootstrapped Drupal site.
    - Kernel: PHPUnit-based tests with a bootstrapped kernel, and a minimal number of extensions enabled.
    - Functional: PHPUnit-based tests with a full bootstrapped Drupal instance. These tests include browser based tests and other tests looking at full subsystems.
    - FunctionalJavascript: PHPUnit-based tests that use Webdriver to perform tests of Javascript and Ajax functionality in the browser.

How run automated tests locally
---------------------------------

See the `Drupal "Running PHPUnit tests" guide <https://www.drupal.org/node/2116263>`_ for instructions on running tests on your local environment. In order to ensure our Tripal functional testing is fully bootstrapped, tests should be run from Drupal core.

If you are using the docker distributed with this module, then you can run tests using:

.. code:: bash

  docker exec --workdir=/var/www/drupal/web/modules/contrib/tripal tripal phpunit

Tripal-focused Testing
------------------------

The following automated testing documentation and tutorials are focused on testing Tripal-specific functionality within Tripal Core and Extension modules. If there is a topic you would like covered that is not yet documented, please add an issue on our github at https://github.com/tripal/tripal_doc/issues!

.. toctree::
   :maxdepth: 2

   testing/tripalTestTrait
   testing/chadoTestTrait
   testing/fields

Additional Resources
----------------------

*Note: The following docs are still relevant for Drupal 10.x to Drupal 11.2.x.*

 - `Official Drupal: Testing Documentation <https://www.drupal.org/docs/testing>`_
 - `Official Drupal: PHPUnit file structure, namespace, and required metadata <https://www.drupal.org/docs/testing/phpunit-in-drupal/phpunit-file-structure-namespace-and-required-metadata>`_
 - `Official Drupal: Running PHPUnit Tests <https://www.drupal.org/docs/testing/phpunit-in-drupal/running-phpunit-tests>`_
 - `Official Drupal: PHPUnit Browser test tutorial <https://www.drupal.org/docs/testing/phpunit-in-drupal/phpunit-browser-test-tutorial>`_
 - `Official Drupal: PHPUnit JavaScript test writing tutorial <https://www.drupal.org/docs/automated-testing/phpunit-in-drupal/phpunit-javascript-test-writing-tutorial>`_
 - `Drupal 8, 9, 10 Functional and Unit Testing (Automation Testing) <https://gurinderpal.medium.com/drupal-8-9-10-functional-and-unit-testing-462993c3ce14>`_
 - `Writing Automated Tests in Drupal 8, Part 4: Kernel tests <https://deninet.com/blog/2019/02/10/writing-automated-tests-drupal-8-part-4-kernel-tests>`_
 - `Writing Automated Tests in Drupal 8, Part 3: Unit tests <https://deninet.com/blog/2019/01/27/writing-automated-tests-drupal-8-part-3-unit-tests>`_
 - `Drupal 8: Writing Your First Unit Test With PHPUnit <https://www.axelerant.com/resources/team-blog/drupal-8-writing-your-first-unit-test-with-phpunit>`_
 - `Envatotuts+: All About Mocking with PHPUnit <https://code.tutsplus.com/all-about-mocking-with-phpunit--net-27252t>`_
 - `Official PHPUnit: Test Doubles <https://docs.phpunit.de/en/10.5/test-doubles.html>`_
