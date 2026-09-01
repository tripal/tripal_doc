Tripal File Usage
===================

Adding a License
------------------
To ensure data files offered by your Tripal site meet
`FAIR data principles <https://www.go-fair.org/fair-principles/>`_,
all files must be associated with a license.
Therefore, before adding any files, you must first define the **License** types that you will need.
A few standard licenses are created when the module is installed, and
you can create as many other **License** types as needed for the data on your site.

To create a new license type, on the shortcuts tool bar click on the Tripal icon.

.. image:: usage.1.tripal-menu.png
      :alt: Tripal shortcut menu appearance

From the drop-down menu select **Content**.
Then click on **+Add Tripal Content**

.. image:: usage.2.add-tripal-content.png
      :alt: Appearance of the Add Tripal Content button

There you can scroll to the **License** type and click on it.

.. image:: usage.3.add-license.png
      :alt: Appearance of the License content type option

To create your license page you can:

 * Option 1: Fully define the license by giving it a name and provide the full description
 * Option 2: Summarize the license by giving a name, providing a brief summary (or no summary)
   and providing the URL to the full license online.

For example:

.. image:: usage.4.add-license.png
      :alt: Example filled-in form for a license

.. note::

  It is best practice to provide a human readable summary of the user's rights in the
  Summary field and to provide a link to the full legal text of the license via the URI field.

Adding a File
---------------

A file can be either located locally on your site, or be a URL that references a location anywhere on the internet.

.. note::

  If you have followed the Tripal User's Guide you will have an analysis appropriate to link
  to the file in the following example, or you can follow
  :ref:`these instructions to create an Analysis page <Create a Genome Assembly Page>`.
  However, linking an analysis is optional.

To create a new file page, on the administrative tool bar click on the Tripal icon.

.. image:: usage.1.tripal-menu.png
      :alt: Tripal shortcut menu appearance

From the drop-down menu select **Content**.
Then click on **+Add Tripal Content**

.. image:: usage.2.add-tripal-content.png
      :alt: Appearance of the 'Add Tripal Content' button

There you can scroll to the **File** type and click on it.

.. image:: usage.5.add-file.png
      :alt: Appearance of the 'File' content type option

On this page you can:

1. Provide a **name** (required) and **description** for the file.
2. Indicate a file **type** (required).
3. Indicate the file **source** (or contact person) who has rights to the data.
4. Indicate the file **location** (either locally or via remote URL).
5. And set the **license** (required).
6. Optionally specify relationships or other linked records, such as analysis or publication.

First, we will create a **file** page to reference a FASTA file for scaffold 1 of the whole genome assembly.
Enter the following in the File page fields:

+---------------------+--------------+--------------------------------------------------------------------------+
| Field               | Value                                                                                   |
+=====================+==============+==========================================================================+
| Name                | *Citrus sinesis* Whole Genome Assembly v1.0 scaffold 1                                  |
+---------------------+--------------+--------------------------------------------------------------------------+
| File Type           | FASTA (format:1929)                                                                     |
+---------------------+--------------+--------------------------------------------------------------------------+
| Description         | The whole genome assembly, v1.0, of *Citrus sinensis* GCA_000695605.1, scaffold 1.      |
+---------------------+--------------+--------------------------------------------------------------------------+
| File Source         | *Leave blank or provide any contact you may have already*                               |
+---------------------+--------------+--------------------------------------------------------------------------+
| File Location       | URI          | https://www.ncbi.nlm.nih.gov/nuccore/KK784873.1?report=fasta&format=text |
+                     +--------------+--------------------------------------------------------------------------+
|                     | File Name    | Citrus sinensis-scaffold00001.fasta                                      |
+                     +--------------+--------------------------------------------------------------------------+
|                     | File Size    | *Leave blank*                                                            |
+                     +--------------+--------------------------------------------------------------------------+
|                     | MD5 Checksum | *Leave blank*                                                            |
+---------------------+--------------+--------------------------------------------------------------------------+
| License             | CC0 1.0 Universal (CC0 1.0) Public Domain Dedication                                    |
+---------------------+--------------+--------------------------------------------------------------------------+
| Analysis (optional) | Whole Genome Assembly and Annotation of Citrus sinensis (JGI)                           |
+---------------------+--------------+--------------------------------------------------------------------------+

.. note::

  Specifying the file type uses an autocomplete field.
  Type the first few letters and then select from the list presented.

  .. image:: usage.6.add-term.png
      :alt: Example autocomplete selecting the FASTA term

.. note::

  A file can have more than one download location, and you can combine both local and remote files.

.. note::

  Providing a file source or "contact" is optional, but is recommended.
  Every file with a license should indicate, via the "file source" field,
  who retains the license rights (if applicable).

After creation, the file page will look similar to this.
In this example, a publication and contact have been included.

.. image:: usage.7.file-created.png
      :alt: Appearance of a completed file entity page

Uploading Files
-----------------

Instead of supplying an external URI, you can upload a file to your site's local filesystem using the
"Browse…" button on the "File Upload" section of the form.

.. image:: usage.8.upload-file.png
      :alt: Appearance of the Browse button used for file upload

The file selected here will be uploaded to a directory as configured for the field,
and once saved, will appear in the URI field with a `public://` prefix.
The default directory uses tokens to place files in a directory path based on the current date.

An uploaded file will appear similar to this after it has been saved:

.. image:: usage.9.uploaded-formatted.png
      :alt: Appearance of an uploaded file, in this case named 'Supplementary File 1.xlsx'

.. note::

  To configure the path used for uploaded files, you can modify this in the settings for the field's form display
  by clicking on the gear icon.
  If you want to restrict the types of files that can be uploaded, you can also configure this list here.

  .. image:: usage.10.manage-form-display-settings.png
      :alt: Appearance of the gear icon in the form display settings for the file location field

Copying files to the filesystem
---------------------------------

You can also manually copy files to your site's filesystem, and enter the
corresponding `public://` URI. For example, if you copy a file to 

`sites/default/files/bulk_data/citrus_project/Citrus_sinensis-scaffold00001.fasta`

then the corresponding URI would be 

`public://bulk_data/citrus_project/Citrus_sinensis-scaffold00001.fasta`

.. note::

  Any locally hosted file using a `public://` URI will have the **File Size** and **MD5 Checksum**
  values automatically populated.

Adding File Metadata
----------------------

Manually Adding Metadata
``````````````````````````

You can add additional metadata to a file by adding new fields to the file content type.

On the shortcuts tool bar click on the Tripal icon.

.. image:: usage.1.tripal-menu.png
      :alt: Tripal shortcut menu appearance

From the drop-down menu select **Page Structure**.
Then on the **Tripal File** content type select **Manage fields**

.. image:: usage.11.manage-fields.png
      :alt: The 'Manage fields' menu item on the 'File' content type

The next page lists existing fields. We want to create a new property field, so click on **+ Create a new field**.

.. image:: usage.12.create-a-new-field.png
      :alt: Appearance of the 'Create a new field' button

You will want to select the **Chado Fields** type

.. image:: usage.13.chado-fields.png
      :alt: Appearance of the 'Chado Fields' field collection selector.

Then you will want to specify a name appropriate for the property you want to add.
For example, we might want to add a field to indicate the language for a document file.

.. image:: usage.14.file-language.png
      :alt: Example label 'File Language' entered into the 'Label' form field

Then find the **Chado property** type and select it.

.. image:: usage.15.chado-property.png
      :alt: The process of selecting the 'Chado Property' field type

One document could contain parts written in different languages, so we probably want
to change the **Allowed number of values** to unlimited.

.. image:: usage.16.cardinality.png
      :alt: Changing the 'Allowed number of values' to unlimited 

Finally, we specify an appropriate controlled vocabulary term for the field. All fields require a term.

.. image:: usage.17.term.png
      :alt: Showing the 'Set the Term' field with the term 'Language (TPUB:0000064)' entered into the field

If we return to any **File** page and edit it, we will now have a new metadata field
for storing the language or languages.

.. image:: usage.18.widget-language.png
      :alt: Appearance of the newly created 'File Language' form field on the 'File' entity widget

.. note::

  You can change the Text Filter Format for a property field. In this example, formatting is not needed,
  so you could change it from `Basic HTML` to `Plain Text` in the **Manage form display** tab of the field settings.

Adding Metadata in Bulk
`````````````````````````

.. warning::

  A method for adding metadata in bulk has not yet been implemented.

Associating a File with Other Content
---------------------------------------

Now that we have a file page, we can associate that file with any other Tripal-based content.
For this example, we will create a genome assembly project and associate the file with that project.

Before we can associate a file with a project, we must first add a new field for the file
to the Project content type.

On the shortcuts tool bar click on the Tripal icon.

.. image:: usage.1.tripal-menu.png
      :alt: Tripal shortcut menu appearance

From the drop-down menu select **Page Structure**.
Then on the Project content type select **Manage fields**

The next page lists existing fields. Now click on **+ Check for new fields**.
The File field should be detected and checked by default.

.. image:: usage.19.add-file-field.png
      :alt: Appearance of the discovered 'File' linking field, in this case with the machine name 'project_file'

Click the **Add fields** button.

Now create a new **Project** page.
On this page will be a field to add one or more files, for example

.. image:: usage.20.file-widget.png
      :alt: Appearance of the 'File' select element, here selecting 'Citrus Sinensis Whole Genome Assembly v1.0 scaffold 1 [FASTA format]'

Once the project is saved, clicking the file link will take the user to the
full file page where they can download the file, view the license information,
and view metadata about the file.

.. note::

  Once the number of files on your site exceeds a configurable limit, which defaults to 50,
  the file select will change to an autocomplete field.

Accessing Files via Web-Services
----------------------------------

.. warning::

  Web services have not yet been implemented in Tripal 4.
  See `Tripal issue 2270 <https://github.com/tripal/tripal/issues/2270>`_ for current status.

Tripal File Module Chado Tables
---------------------------------

The license Table
```````````````````

The *license* table houses the base license record.
The *name* field must be a unique value for each file and thus can be selected on for finding licenses.
The *uri* field can be null, but if not null, it must be unique for each license.

+-------------+-------------------------+------+---------------+---------------------------+
| Column      | Type	                | Null | Default Value | Constraint                |
+=============+=========================+======+===============+===========================+
| license_id  | bigint                  | No   | (auto)        | Primary Key               |
+-------------+-------------------------+------+---------------+---------------------------+
| name        | character varying(1024) | No   |               | Unique                    |
+-------------+-------------------------+------+---------------+---------------------------+
| summary     | text                    | Yes  |               |                           |
+-------------+-------------------------+------+---------------+---------------------------+
| uri         | text                    | Yes  |               | Unique or null            |
+-------------+-------------------------+------+---------------+---------------------------+

The file Table
````````````````

The *file* table houses the base file record.
The *name* field must be a unique value for each file and thus can be selected on for finding files.

+-------------+------------+------+---------------+---------------------------+
| Column      | Type	   | Null | Default Value | Constraint                |
+=============+============+======+===============+===========================+
| file_id     | bigint     | No   | (auto)        | Primary Key               |
+-------------+------------+------+---------------+---------------------------+
| name        | text       | No   |               | Unique                    |
+-------------+------------+------+---------------+---------------------------+
| type_id     | integer    | No   |               | Foreign Key to **cvterm** |
+-------------+------------+------+---------------+---------------------------+
| description | text       | Yes  |               |                           |
+-------------+------------+------+---------------+---------------------------+

The fileprop Table
````````````````````

The *fileprop* table holds the properties or metadata about files.
The CV term is specified using the *type_id* column
and the rank is incremented if multiple values of the same type are stored.

+-------------+------------+------+---------------+---------------------------+
| Column      | Type	   | Null | Default Value | Constraint                |
+=============+============+======+===============+===========================+
| fileprop_id | bigint     | No   | (auto)        | Primary Key               |
+-------------+------------+------+---------------+---------------------------+
| file_id     | integer    | No   |               | Foreign Key to **file**   |
+-------------+------------+------+---------------+---------------------------+
| type_id     | integer    | No   |               | Foreign Key to **cvterm** |
+-------------+------------+------+---------------+---------------------------+
| value       | text       | Yes  |               |                           |
+-------------+------------+------+---------------+---------------------------+
| rank        | integer    | No   | 0             |                           |
+-------------+------------+------+---------------+---------------------------+

The fileloc Table
```````````````````

The *fileloc* table indicates where files can be downloaded.
The *uri* column must contain the URI of the file.
Even local files have a URI.
For example a Drupal URI usually has a *public://* URI prefix.
For example: *public://bulk_data/citrus_project/Citrus_sinensis-scaffold00001.fasta*.
When a file has more than one location to download the records can be ordered by setting the *rank* column.
The Tripal file module automatically fills in the *size* and *md5checksum* values for local files.

+-------------+-------------------------+------+---------------+---------------------------+
| Column      | Type                    | Null | Default Value | Constraint                |
+=============+=========================+======+===============+===========================+
| fileloc_id  | bigint                  | No   | (auto)        | Primary Key               |
+-------------+-------------------------+------+---------------+---------------------------+
| file_id     | integer                 | No   |               | Foreign Key to **file**   |
+-------------+-------------------------+------+---------------+---------------------------+
| uri         | text                    | No   |               |                           |
+-------------+-------------------------+------+---------------+---------------------------+
| rank        | integer                 | No   | 0             |                           |
+-------------+-------------------------+------+---------------+---------------------------+
| md5checksum | character(32)           | Yes  |               |                           |
+-------------+-------------------------+------+---------------+---------------------------+
| size        | character varying(1024) | Yes  |               |                           |
+-------------+-------------------------+------+---------------+---------------------------+
| filename    | text                    | Yes  |               |                           |
+-------------+-------------------------+------+---------------+---------------------------+
