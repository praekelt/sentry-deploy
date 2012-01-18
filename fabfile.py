from fabric.api import cd, prefix, run, sudo

def restart():
    sudo('/etc/init.d/nginx restart')
    sudo('supervisorctl reload')

def provision():
    sudo('apt-get update')
    sudo('apt-get install -y git-core puppet')
    run('git clone https://github.com/praekelt/sentry-deploy.git')
    with cd('sentry-deploy'):
        sudo('puppet ./manifests/sentry.pp --modulepath ./manifests/modules')
    with cd('/var/praekelt/sentry'):
        with prefix('. ve/bin/activate'):
            sudo('sentry manage --config=sentry.conf.py syncdb')
            sudo('sentry manage --config=sentry.conf.py migrate')
    restart()
    run('rm -rf ~/sentry-deploy')
