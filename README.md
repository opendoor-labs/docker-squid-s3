# Introduction

A `Dockerfile` to run a Squid caching proxy in SSL mode, intended to
accelerate secure downloads from Amazon S3. Derived from:
https://github.com/sameersbn/docker-squid.git

# Use within Boto.

To activate, first configure an HTTP forward proxy in boto
(e.g.: S3Connection(proxy=os.getenv(“SQUID_HOST”), proxy_port=os.getenv(“SQUID_PORT”)))

Then Amazon HTTPS download requests are not cacheable by default. To make a
file opt-in cacheable, pass response_headers={'response-cache-control': 'public, max_age=36000’}
on the download requests, for example:

key.get_contents_to_filename(…,
    response_headers={'response-cache-control':
                      'public, max_age=36000’})
