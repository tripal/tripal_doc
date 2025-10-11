
Tips & Tricks
===============

This page provides useful short snippets of code to help module developers upgrade their Tripal v3 compatible modules to work with Drupal 10. This list is not comprehensive or complete, but is meant to be an aid.

tripal_set_message() and tripal_report_error()
---------------------------------------------------

These functions have been upgraded and thus can be used as is. However, the new way is to use a logger service. For example:

.. code-block:: php

  $logger = \Drupal::service('tripal.logger');
  $logger->notice('Hello world');
  $logger->error('Hello world');

For more detailed information see the :ref:`Tripal Logger` documentation.

drupal_set_message()
----------------------

Changelog: https://www.drupal.org/node/2774931

.. code-block:: php

  use Drupal\Core\Messenger\MessengerInterface;
  // if not set by constructor...
  $this->messenger = \Drupal::messenger();

  // Add specific type of message within classes.
  $this->messenger->addMessage('Hello world', 'custom');
  $this->messenger->addStatus('Hello world');
  $this->messenger->addWarning('Hello world');
  $this->messenger->addError('Hello world');

  // In procedural code:
  $messenger = \Drupal::messenger();
  $messenger->addMessage('Hello world', 'custom');
  $messenger->addStatus('Hello world');
  $messenger->addWarning('Hello world');
  $messenger->addError('Hello world');

format_date()
-------------

.. code-block:: php

  \Drupal::service('date.formatter')->format($time);

Loading a User Object
---------------------
To load a user using a known user ID.

.. code-block:: php

   // Load a user with a known UID in the $uid variable.
   $user = \Drupal\user\Entity\User::load($uid);

To get the current user:

.. code-block:: php

   $current_user = \Drupal::currentUser();
   $user = \Drupal\user\Entity\User::load($current_user->id());


Creating Links
--------------
To create HTML links the Drupal 7 approach was:

.. code-block:: php

  $link = l('Administration', '/admin')


The Drupal 10 approach is:

.. code-block:: php

   use Drupal\Core\Link;
   use Drupal\Core\Url;

   $link = Link::fromTextAndUrl('Administration', Url::fromUri('internal:/admin'))

Using Links in `drupal_set_message`:

.. code-block:: php

      $jobs_url = Link::fromTextAndUrl('jobs page',
        Url::fromUri('internal:/admin/tripal/tripal_jobs'))->toString();
      drupal_set_message(t("Check the @jobs_url for status.",
        ['@jobs_url' => $jobs_url]));



Attaching CSS
-------------
In Drupal 10 CSS files are part of "libraries".  Libraries are groups of "assets" such as CSS, JS, or other resources needed for a particular set of pages that the module provides.  Libraries are defined in the `<module_name>.libraries.yml` file.  For information about preparing your CSS files with drupal see the page about `adding css and js files to a module <https://www.drupal.org/node/2274843>`_.  Once the CSS is setup correctly, you want to add "libraries" to pages that use them.  This is done by adding an '#attached' element to the render array returned by a page using the following form:

.. code-block:: php

   '#attached' => [
     'library' => ['<module_name>/<library_name>'],
   ]

Replace `<module_name>` and `<library_name>` with appropriate values.
