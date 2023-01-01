import re, subprocess
def get_keychain_pass(account=None):
    params = {
        'command': 'pass',
        'account': account,
    }
    command = "%(command)s show %(account)s | head -n 1" % params
    output = subprocess.check_output(command, shell=True, stderr=subprocess.STDOUT)
    return output.strip().decode() 
