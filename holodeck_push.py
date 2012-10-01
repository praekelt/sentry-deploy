#!/usr/bin/env python

from datetime import datetime
import random
import time

from photon import Client

client = Client(
    server="http://holodeck.praekelt.com",
)

client.send(
    samples=(
        ("Line 1", random.randint(100, 999)),
        ("Line 2", random.randint(100, 999)),
        ("Line 3", random.randint(100, 999)),
        ("Line 4", random.randint(100, 999)),
        ("Line 5", random.randint(100, 999)),
    ),
    api_key='fba3be2b97e14b6fbf32e934d757c705',
    timestamp=datetime.now(),
)
