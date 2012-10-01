#!/usr/bin/env python

import os
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "sentry_conf")

from datetime import datetime

from photon import Client
from sentry.models import Event
from sentry.models import Project


client = Client(
    server="http://holodeck.praekelt.com",
)

samples = []
for project in Project.objects.all():
    samples.append((project.name, Event.objects.filter(project=project).count()))

client.send(
    samples=samples,
    api_key='fba3be2b97e14b6fbf32e934d757c705',
    timestamp=datetime.now(),
)
