import requests
import pytest
import subprocess
import time

BASE = "http://127.0.0.1:8080"

@pytest.fixture(scope="module")
def port_forward():
    # Forward service port to local 8080 (requires kubectl and cluster available)
    p = subprocess.Popen(["kubectl", "port-forward", "-n", "production", "svc/sample-app", "8080:80"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    time.sleep(2)
    yield
    p.terminate()
    p.wait()

def test_root(port_forward):
    r = requests.get(BASE + "/", timeout=5)
    assert r.status_code == 200
