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
    "python-pip",
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

exec { "clone_repo":
    command => "git clone https://github.com/praekelt/sentry-deploy.git",
    cwd => "/var/praekelt",
    unless => "test -d /var/praekelt/sentry",
    subscribe => [
        Package['git-core'],
        File['/var/praekelt/'],
    ]
}
