
Jobs (longer-running tasks)
=============================

Often times when dealing with biological data, the dataset size means that actions need to be done outside the page load. This is supported by Tripal through a jobs system that allows you to

1. Submit jobs on behalf of a user during a page load process.
2. The job is registered with the Tripal Jobs system.
3. Either you manually run it on the command line via drush or you set up a daemon or cron job to do so automatically. This allows the job longer execution time and to take better advantage of server resources.
4. When the job is complete, the results are represented in the front end.

Register a Tripal Job
-----------------------

To register a job with the Tripal Jobs service we use the `tripal.job` service create method.

As an example, consider the situation where your extension module provides a page to visualize a particular dataset. You have materialized views to allow you to provide the visualization within the page load, but you want to provide a link allowing users to download the dataset for further analysis.

One way to do this is to create a service to prepare the dataset as a file but clearly that may not be feasible to do in the page load. Instead, you can create a button that runs the following snippet of code to register a job to complete this with Tripal. Then in your service, you create a public static method to setup and execute your service.

.. code-block:: php

  $current_user =  \Drupal::currentUser();
  $job_id = \Drupal::service('tripal.job')->create([
    'job_name' => 'Export dataset NAME from visualization',
    'modulename' => 'trpextension',
    'callback' => [\Drupal\trpextension\Services\ExportVizData::class ,'runTripalJob'],
    'arguments' => [
      'viz_id' => 123,
      'dataset_analysis_id' => 369,
      'filename' => 'public://datasetNAME.' . $current_date . '.csv',
    ],
    'uid' => $current_user->id(),
  ]);

The above snippet assumes that your modulename is `trpextension` and expects the following companion static method in your `\Drupal\trpextension\Services\ExportVizData` service. Note that we provide the information needed to the job in the arguements
array and then those are passed to the job callback as parameters with the TripalJob object being the last parameter.

.. code-block:: php

  namespace \Drupal\trpextension\Services\;

  use Drupal\Core\DependencyInjection\ServiceProviderBase;
  use \Drupal\tripal\Services\TripalJob;

  class ExportVizData extends ServiceProviderBase {

    /**
     * Creates an instance of this service to export the dataset.
     *
     * NOTE: expected to be run by the Tripal Jobs system.
     *
     * @param int $viz_id
     *  The identifier of the visualization that was being viewed.
     * @param int $dataset_analysis_id
     *  The chado.analysis_id of the dataset to be exported.
     * @param string $filename
     *  The name of the file to save the exported data in.
     */
    public static function runTripalJob(int $viz_id, int $dataset_analysis_id, TripalJob $job) {

      // Create an instance of this service.
      /** @var \Drupal\tripal\Services\ExportVizData $service */
      $service = \Drupal::service('trpextension.exportviz');

      // Now actually create the export.
      $service->export($viz_id, $dataset_analysis_id, $filename);
    }

Callback
^^^^^^^^^^

Tripal 4 supports the following three types of callables for the callback parameter:

 - **Simple function**: this is the method that was used in Tripal 2/3 where you provide a function that is usually in an include file or the module file. This approach is not recommend but still fully supported.
 - **String-base Static Callback**: this method allows you to specify a static function in a string. You must include the full namespace, class and method. For example, `\Drupal\trpextension\Services\ExportVizData::runTripalJob`.
 - **Array-based Static Callback**: this method is equivalent to the string-based approach but some feel is more readible. Here the callback is an array where the first element is the class and the second arguement is the name of the static method. For example, `[\Drupal\trpextension\Services\ExportVizData::class, 'runTripalJob']`.

In the case of the function, you need to ensure the php file containing the function is included in the page. In the case of the other two class-based options, Drupal will automatically include the class based on the namespace.

You can `read more about PHP callables at php.net <https://www.php.net/manual/en/language.types.callable.php>`_.

.. warning::

  While php also supports passing an object paired with a non-static method name, Tripal Jobs does not support this as the callback is stored in the database. Additionally, an anonymous function is not recommend or tested for the same reasons.

Get information about a job
-----------------------------

You may often find you also need the ability in your extension module to retrieve information about a specific job. Expanding on the previous example in registering a Tripal Job above, perhaps you want to check on the status of your users' export job in order to let them know when it is complete and provide their results.

When you created the tripal job before, you would have had the job_id returned to you. This unique identifier can be used to access all the information you need! You can store it in the form_state if you registered the job in a multipage form or you can save it in the URL in the case of an export button redirecting to a results page.

Regardless of how you keep track of the job identifier, the following code can be used to retrieve details about the job:

.. code-block:: php

  // Create a TripalJob object and use the load method to make it represent
  // your particular job of interest.
  $job = new \Drupal\tripal\Services\TripalJob();
  $job->load($job_id);

  // Now you can use a number of different "getter" methods to retrieve info.
  // Check if the job is running and if so, get the percentage complete.
  $status = $job->isRunning();
  if ($status === TRUE) {
    $progress == $job->getProgress();
  }
  // Or just check the status.
  // This will return a human-readable string like 'Waiting', 'Cancelled',
  // 'Running', 'Completed', or 'Error'.
  $status = $job->getStatus();

  // You can also retrieve the arguments that you passed into the job.
  // We're grabbing the filename we asked the exported dataset to be saved in
  // here when we find out the job is complete without error.
  if ($status == 'Complete') {
    $arguments = $job->getArguments();
    $url = Url::fromUri($arguments['filename']);
    $link = Link::fromTextAndUrl('access your results here', $url);
    \Drupal::messenger()->addStatus("The export is complete and you can " . $link->toString());
  }
