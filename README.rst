Sentry Deploy
=============

Simple Fabric and Puppet scripts provisioning Sentry on a remote host or local `Vagrant <http://http://vagrantup.com/>`_ instance.

Remote Host Fabric Deploy
-------------------------

Provisioning
++++++++++++
To provision a new Sentry instance on a remote host run the following command with a user having superuser priviliges on the remote host:: 
    
    $ fab -H hostname:port -u user provision

After the provision access the Sentry dashboard by hitting the hostname in your browser.

Restart
+++++++
To restart a remote Sentry instance previously provisioned run the following command with a user having superuser priviliges on the remote host:: 
    
    $ fab -H hostname:port -u user restart

This will restart `Nginx <http://wiki.nginx.org/Main>`_ and reload `Supervisor <http://supervisord.org/>`_, thus restarting Sentry.


Local Vagrant Deploy
--------------------
Deploy a local Vagrant instance like so::
    
    you@host$ git clone https://github.com/praekelt/sentry-deploy.git
    you@host$ cd sentry-deploy
    you@host$ vagrant up
    you@host$ vagrant ssh
    vagrant@lucid32$ sudo -i
    root@lucid32$ cd /var/praekelt/sentry
    root@lucid32$ . ve/bin/activate
    (ve)root@lucid32$ sentry --config=sentry_conf.py syncdb
    (ve)root@lucid32$ sentry --config=sentry_conf.py migrate
    (ve)root@lucid32$ /etc/init.d/nginx restart
    (ve)root@lucid32$ supervisorctl reload

Then access the Sentry dashboard on `localhost port 4567 <http://localhost:4567/1/>`_.

