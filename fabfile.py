from fabric.api import cd, run, settings, sudo

def restart():
    sudo('/etc/init.d/nginx restart')
    sudo('supervisorctl reload')

def provision():
    with settings(warn_only=True):
        sudo('apt-get update')
        sudo('apt-get install -y git-core puppet')
        run('git clone https://github.com/praekelt/sentry-deploy.git')
        with cd('sentry-deploy'):
            sudo('puppet ./manifests/sentry.pp --modulepath ./manifests/modules')
        sudo('cd /var/praekelt/sentry', user='ubuntu')
        sudo('sentry manage --config=sentry.config.py syncdb', user='ubuntu')
        sudo('sentry manage --config=sentry.config.py migrate', user='ubuntu')
        restart()
