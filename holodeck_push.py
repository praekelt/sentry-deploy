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

client.send(
    samples=(('Mom Connect Daily Errors', Event.objects.filter(project__slug='mom-connect').count())),
    api_key='3bc93b5e0f8d4c30936ad5786b185007',
    timestamp=datetime.now(),
)

client.send(
    samples=(('Central Daily Errors', Event.objects.filter(project__slug='praekelt-central').count())),
    api_key='160d43a54e244ee59d5486cc384cade0',
    timestamp=datetime.now(),
)

client.send(
    samples=(('Ummeli Daily Errors', Event.objects.filter(project__slug='ummeli').count())),
    api_key='e54bb71a19c34f29aafdf18dcbf12941',
    timestamp=datetime.now(),
)

client.send(
    samples=(('Vumi Go Errors', Event.objects.filter(project__slug='vumi-go').count())),
    api_key='a9ddd0ff05284e6c9d9d79be913be88b',
    timestamp=datetime.now(),
)

