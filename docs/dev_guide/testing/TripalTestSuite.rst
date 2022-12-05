Tripal Test Suite
===================

The Tripal Test Suite is the core set of automated tests distributed with Tripal. These docs will give you an overview of where these tests are located within the codebase and what groups of tests are available.

Where are they located?
------------------------

You can find the tests for any Drupal module in the `tests` directory. Since Tripal core is composed of a number of submodules, you will find our test suite covers a number of directories:

- Tripal Core (`tripal/tests`): these tests are focused on core functionality which is available to all Tripal sites.
- Tripal Chado (`tripal_chado/tests`): here we test all interactions with the Chado database including database management, fields and Chado integration with core APIs such as Tripal DBX.
- Tripal BioDB (`tripal_biodb/tests`): these tests focus on the Tripal BioTask API for managing database focused tasks which can benefit from advanced locking.

You will notice that in each of these test directories, there are a number of subdirectories. These are there by Drupal convention.

- fixtures: this is where any SQL files or mock classes should go for setting up your tests.
- src:

    - Unit: PHPUnit-based tests with minimal dependencies. These should focus on testing specific methods using mock objects and should not require a fully bootstrapped Drupal site.
    - Kernel: PHPUnit-based tests with a bootstrapped kernel, and a minimal number of extensions enabled.
    - Functional: PHPUnit-based tests with a full bootstrapped Drupal instance. These tests include browser based tests and other tests looking at full subsystems.
    - FunctionalJavascript: PHPUnit-based tests that use Webdriver to perform tests of Javascript and Ajax functionality in the browser.
