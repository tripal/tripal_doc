
Error Reporting and Logging
===========================

Tripal Logger
-------------

The Tripal logger service can be used to report status and errors to both the site user and to site administrators through the server log. A basic example is

.. code-block:: php

  $logger = \Drupal::service('tripal.logger');
  $logger->notice('Hello world');
  $logger->warning('Hello world');
  $logger->error('Hello world');

There are eight levels of logging available. In order of increasing severity they are:
`debug`, `info`, `notice`, `warning`, `error`, `critical`, `alert`, `emergency`

The log message can be a simple quoted PHP string, or a string that utilizes placeholders. In the latter case, pass in an associative array of placeholder keys and values into the second parameter. For example:

.. code-block:: php

  $options = [];
  $logger->error('Error, status code @errornumber, error message @message', [
    '@errornumber' => $resultcode,
    '@message' => $errormessage,
  ], $options);

There are a few settings that can be passed in using the third ``$options`` parameter to control where the message is sent.

  Use ``$options['drupal_set_message'] = TRUE;`` if you want the message to appear on the user's screen, default is ``FALSE``.

  Use ``$options['logger'] = FALSE;`` if you do NOT want the message to go to the log at `/admin/reports/dblog`, default is ``TRUE``.

The logger checks the ``TRIPAL_SUPPRESS_ERRORS`` environment variable. If it is defined with the value ``true`` (case insensitive), then all logging is suppressed even if it is not an "error" message. This is generally only used for automated testing to prevent output from being printed.

An additional pair of options is available for implementing progress bars. For the first message, set ``$options['is_progress_bar'] = TRUE;`` and ``$options['first_progress_bar'] = TRUE;``
For subsequent updates to the progress bar, only set ``$options['is_progress_bar'] = TRUE;``
It is likely for a progress bar that you will also want to include ``$options['logger'] = FALSE;`` to avoid overpopulating your server log.

