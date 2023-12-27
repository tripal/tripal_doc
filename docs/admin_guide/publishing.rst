Publishing
==========

When creating new Tripal content types, data is stored in the database backend (typically Chado) as well as in Tripal-specific tables automatically. However, other forms of data loading may not automatically publish the data. This means that the information may be stored in Chado, but is not readily available to view on the site. In order to get this data to appear and be accessible to users, it must be published.

The process of publishing data from the storage backend (e.g. Chado) creates Tripal content types such as Organisms, mRNA, genes, and analyses. Tripal knows how to read from the tables where this data is stored because each field in the content type has its source table defined.

To publish Tripal content from the storage backend, navigate to **Admin** → **Content** and click the **Tripal Content** tab, then **Publish Tripal Content** or go to `admin/content/bio_data/publish`.

On the **Publish Tripal Content** page, you'll see a form where you can select which data to publish.
 1. Choose the storage backend. On a standard Tripal site, by default this will be Chado. Your site may have multiple storage backends. If your storage backend has multiple versions, for instance if you have multiple Chado schemas, an additional dropdwon will appear with that option.
 2. Once the storage backend and schema is chosen, the Content Type dropdown will populate with content types that are supported by that backend.
 3. Submit the publishing job. A command will be given for you to create a job via Drush on the command line. If you have the Tripal Job Daemon enabled, it will be run automatically. More information on the Tripal Job Daemon can be found on the :doc:`jobs` page.
 4. Repeat this process for any other content types you want to publish.