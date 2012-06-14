# Globally set exec paths and user.
Exec {
    path => ["/bin", "/usr/bin", "/usr/local/bin"],
    user => 'ubuntu',
}

# Update package index.
exec { "update_apt":
    command => "apt-get update",
    user => "root",
}

# Install required packages.
package { [
    "git-core",
    "libpq-dev",
    "postgresql",
    "python-dev",
    "python-pip",
    "python-virtualenv",
    "supervisor",
    "nginx",
    ]:
    ensure => latest,
    subscribe => Exec['update_apt'];
}

# Ensure Ubuntu user exists
user { "ubuntu":
    ensure => "present",
    home => "/home/ubuntu",
    shell => "/bin/bash"
}

# Create the deployment directory
file { "/var/praekelt/":
    ensure => "directory",
    owner => "ubuntu",
    subscribe => User["ubuntu"]
}

# Clone and update repo.
exec { "clone_repo":
    command => "git clone https://github.com/praekelt/sentry-deploy.git sentry",
    cwd => "/var/praekelt",
    unless => "test -d /var/praekelt/sentry",
    subscribe => [
        Package['git-core'],
        File['/var/praekelt/'],
    ]
}

exec { "update_repo":
    command => "git pull origin",
    cwd => "/var/praekelt/sentry",
    subscribe => [
        Exec['clone_repo'],
    ]
}

# Create virtualenv and install packages.
exec { 'create_virtualenv':
    command => 'virtualenv --no-site-packages ve',
    cwd => '/var/praekelt/sentry',
    unless => 'test -d /var/praekelt/sentry/ve',
    subscribe => [
        Package['libpq-dev'],
        Package['python-dev'],
        Package['python-virtualenv'],
        Exec['clone_repo'],
    ]
}

exec { 'install_packages':
    command => '/bin/sh -c ". ve/bin/activate && pip install -r requirements.pip --upgrade && deactivate"',
    cwd => '/var/praekelt/sentry',
    subscribe => [
        Exec['create_virtualenv'],
        Exec['update_repo'],
    ]
}

# Manage Nginx symlinks.
file { "/etc/nginx/sites-enabled/sentry.conf":
    ensure => symlink,
    target => "/var/praekelt/sentry/nginx/sentry.conf",
    require => [
        Exec['update_repo'],
        Package['nginx'],
    ]
}

file { "/etc/nginx/sites-enabled/default":
    ensure => absent,
    subscribe => [
        Package['nginx'],
    ]
}

# Manage supervisord symlinks.
file { "/etc/supervisor/conf.d/sentry.conf":
    ensure => symlink,
    target => "/var/praekelt/sentry/supervisord/sentry.conf",
    subscribe => [
        Exec['update_repo'],
        Package['supervisor']
    ]
}

# Create Postgres role and database.
postgres::role { "sentry":
    password => sentry,
    ensure => present,
    subscribe => Package["postgresql"],
}

postgres::database { "sentry":
    owner => sentry,
    ensure => present,
    template => "template0",
}
