# Gif-em
A personal GIF manager. _Pronounced GIFF-EM, with a Hard G._


# Installation

* Clone repo
* `bundle install`
* Set up your `application.yml` ([see below](#aws-configuration))
* `bundle exec rake db:create db:migrate`

## AWS Configuration

You'll need an S3 bucket and AWS credentials. [Instructions for setting that up can be found in the Anaconda repo.](https://github.com/forgeApps/anaconda#configuration)

Be sure to follow the instructions for setting up an IAM user and CORS.

Place the credentials and bucket details into a file as below:

    # config/application.yml
    AWS_ACCESS_KEY: MYAWSACCESSKEY
    AWS_SECRET_KEY: SUPSERDEDUPERSECRETKEY
    AWS_BUCKET:     my-gif-em-bucket
    AWS_ENDPOINT:   s3.amazonaws.com/my-gif-em-bucket

Optionally, you may use a custom domain for your image host. To do this, configure your S3 bucket and domain and then add the following to your `application.yml`

    #IMAGE_HOSTNAME: my-gif-em-domain.io

# Importing

If you already have a gif library, upload them all into your S3 bucket using the console into a folder called `bulk-uploaded`.

Then run the contents of the `bulk_import.rb` file in your rails console after updating the paths to point to your images directory.

When uploading, be sure to set the permissions to `public`.