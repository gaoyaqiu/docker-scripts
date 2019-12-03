#!/usr/bin/env python
# Copyright TrueAccord 2014
#
# Author: Nadav S. Samet <nadavsr@trueaccord.com>

DOCUMENTATION = '''
---
module: health_check.py
short_description: Checks that an HTTP server is responding as expected.
description:
    - Sends multiple HTTP requests to a URL until the expected response is
      received. The number of retries, the delay between retries as well as
      the expected response are configurable.

    - Install this module by putting the file C(health_check.py) in a directory
      named C(library) under your playbook or role directory.

notes:
    - Requires urllib2

options:
    url:
        description:
            - URLs to perform health checks on.
        required: true
    headers:
        description:
            - Dictionary of HTTP headers to send in the request.
        default: null
    initial_delay:
        description:
            - Number of seconds to wait before sending the first request.
        default: '0'
    delay_between_tries:
        description:
            - Number of seconds to wait between tries.
        default: 5
    max_retries:
        description:
            - Number of times to try before giving up.
        default: 10
    timeout:
        description:
            - Number of seconds to wait for a response for each request. If
              a response is not received within this number of second, the
              attempt is considered to be a failure.
        default: 10
    expected_status:
        description:
           - Expected HTTP status code. If the server responds with a
             different status code, then the attempt is considered to be
             a failure.
        default: 200
    expected_text_to_have:
        description:
           - An optional text that the response should contain
        required: false
        default: null
'''

EXAMPLES = '''
# Performs a health check for a remote server from the machine running the
# play.

- name: Wait for server to pass health-checks
  health_check.py:
  url: http://{{ inventory_name }}
  delegate_to: 127.0.0.1

# Runs a health check for an HTTP server running on the current host.
# passes an Host header to reach the virtual host we want to test.

- name: Wait for API to pass health-check
  health_check.py:
    url: http://127.0.0.1/api/v1/ok
    delay_between_tries: 5
    max_retries: 20
    headers:
      Host: api.example.com
    expect_to_have_text: 'ok'
'''

# noinspection PyInterpreter
from ansible.module_utils.basic import *
import httplib
import re
import socket
import time
import urllib2


def check_server_status(url, headers, timeout, expected_status,
                        expect_to_have_text):
    request = urllib2.Request(url, headers=headers)
    try:
        fp = urllib2.urlopen(request, timeout=timeout)
    except (urllib2.URLError, httplib.HTTPException, socket.error), e:
        return False, str(e)

    if fp.getcode() != expected_status:
        return False, 'Expected status %d, actual: %d' % (
            expected_status, fp.getcode())

    content = fp.read()
    fp.close()

    if expect_to_have_text and content.find(expect_to_have_text) != -1:
        return False, 'Content did not match expected text.'

    return True, 'OK'

def main():
    module = AnsibleModule(
        argument_spec = dict(
            url = dict(required=True),
            headers = dict(required=False, type='dict', default=None),
            initial_delay = dict(required=False, type='int', default=0),
            delay_between_tries = dict(required=False, type='int', default=5),
            max_retries = dict(required=False, type='int', default=50),
            timeout = dict(request=False, type='int', default=10),
            expected_status = dict(request=False, type='int', default=200),
            expect_to_have_text = dict(request=False, default=None)
        )
    )

    url = module.params['url']
    headers = module.params['headers'] or {}
    initial_delay = module.params['initial_delay']
    delay_between_tries = module.params['delay_between_tries']
    max_retries = module.params['max_retries']
    timeout = module.params['timeout']
    expected_status = module.params['expected_status']
    expect_to_have_text = module.params['expect_to_have_text']

    time.sleep(initial_delay)
    info = ''
    for attempt in xrange(max_retries):
        if attempt != 0:
            time.sleep(delay_between_tries)
        success, info = check_server_status(
                url=url, headers=headers, timeout=timeout,
                expected_status=expected_status,
                expect_to_have_text=expect_to_have_text)
        if success:
            module.exit_json(status="healthy")
    else:
        module.exit_json(status="faulty")

main()

