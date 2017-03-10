#!/usr/bin/env python
#
# Class for adding a device to Service Center via the Spotlight API.
#
# Here is a snippet of code that will add a device using minimal fields
# for the input data:
#
# from ScDeviceLoader import ScDeviceLoader
#
# # The data dictionary for the device:
# device_data = {
#     "vendor_id": "HP",
#     "vendor_model": "MODEL123",
#     "serial_number": "ABC123TESTX001",
#     "company_use": "SUNGARD",
#     "company_own": "SUNGARD",
#     "contracting_company": "SUNGARD",
#     "location": "PA.PHILADELPHIA.011",
#     "ip_address": "67.67.67.1",
#     "ip_hostname": "my-bogus-test-1",
#     "server_os": "LINUX",
#     "istatus": "Installed-Active"
# }
#
# # Get a device loader object (note: not giving args will use defaults
# # for staging).
# scdl = ScDeviceLoader(api_url=xxxx, api_token=xxxx)
#  
# # Add the device
# result = scdl.addDevice(device_data)
#
# # If there was no error, result will contain data that looks like this:
#
#  {
#      'acquisition_date': None,
#      'active_date': None,
#      'asset_guid': '390CD8A6-E492-11E5-B59A-E4115BBFDD48',
#      'asset_tag': None,
#      'building': None,
#      'comments': None,
#      'contracting_company': {
#         'company': 'SunGard',
#         'company_guid': '76C6F530-40C1-446D-A5D5-A66E78605149',
#         'id': 'SUNGARD'
#      },
#      'description': None,
#      'floor': None,
#      'format_name': None,
#      'history': '',
#      'hostname': 'MY-BOGUS-TEST-1',
#      'ip_address': '67.67.67.1',
#      'ip_desc': None,
#      'ip_host': 'my-bogus-test-1',
#      'last_update': '2016-03-07T18:27:17Z',
#      'location': 'PA.PHILADELPHIA.011',
#      'location_code': None,
#      'logical_name': 'SVR0000023952',
#      'managed_by': None,
#      'name': 'my-bogus-test-1',
#      'os_version': None,
#      'owner_company': {
#         'company': 'SunGard',
#         'company_guid': '76C6F530-40C1-446D-A5D5-A66E78605149',
#         'id': 'SUNGARD'
#      },
#      'part_no': None,
#      'production_state': 'Pending Implementation',
#      'real_room': '',
#      'remove_date': None,
#      'room': None,
#      'serial_number': 'ABC123TESTX001',
#      'server_os': 'LINUX',
#      'status': 'Fully Managed',
#      'subtype': None,
#      'sysmodtime': '2016-03-07T18:27:17Z',
#      'type': 'server',
#      'updated_by': 'spotlight',
#      'usage_category': None,
#      'user_company': {
#         'company': 'SunGard',
#         'company_guid': '76C6F530-40C1-446D-A5D5-A66E78605149',
#         'id': 'SUNGARD'
#      },
#      'vendor_id': 'HP',
#      'vendor_model': 'MODEL123',
#      'warranty': None
#  }
#
# # If there is an error with the addDevice call, it will print an error
# # message and return nothing.  You can still get all of the response
# # data (actually, the Response object) from scdl._last_resp.
# 
##################### ScDeviceLoader Class code #######################
#
import sys
import requests

def_api_url = 'https://staging.sl.tools.sgns.net/api/sc/servers'
def_api_token = '5bc63cd5088e4d5c4c0ed3fefa1aff43'

requests.packages.urllib3.disable_warnings()

class ScDeviceLoader:
    """
    """
    sess = None

    def __init__(self, api_url=def_api_url, api_token=def_api_token):
        self.url = api_url
        self.token = api_token
        self.getSession()

    def getSession(self):
        self.sess = requests.Session()        
        self.sess.headers['Authorization']='Token token=%s' % self.token
        self.sess.headers['Content-Type']='application/json'

    def addDevice(self, data):
        if not self.sess:
            self.getSession()
        self._last_resp = self.sess.post(self.url, json=data)
        # On a 200 response return the result data from SC
        if self._last_resp.status_code == 200:
            return self._last_resp.json().get('result', {})
        # Other wise complain
        print "Got HTTP Error: %s from query to Spotlight" % self._last_resp.status_code
        return None
