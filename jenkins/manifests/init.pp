# Class: jenkins
# ===========================
#
# Full description of class jenkins here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'jenkins':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2018 Your name here, unless otherwise noted.
#
class jenkins (
  $repo_url = 'https://pkg.jenkins.io/redhat-stable/jenkins.repo',
  $key_url  = 'https://pkg.jenkins.io/redhat-stable/jenkins.io.key',
  $dport    = '8080',
  $sport    = '9000',
){

  if ! defined(Package['wget']) {
    package { 'wget':
      ensure =>  present,
      before => Exec[jenkins_repo], 
    }
  }

  exec { 'jenkins_repo' :
    path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    command => "wget -O /etc/yum.repos.d/jenkins.repo $repo_url",
    before   => Package[jenk_inst],
  }

   exec { 'add_gpg_key' :
     path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
     command => "rpm --import $key_url",
     before   => Package[jenk_inst],
   }

  package { 'jenk_inst':
    name   => 'jenkins',
      ensure => installed,
      provider => 'yum',
  }

  service { 'jenkins':
    ensure     => running,
    name       => 'jenkins',
    hasrestart => true,
    hasstatus  => true,
    enable     => true,
  }

  exec { 'firewall-cmd':
    command => "firewall-cmd --zone=public --add-port=${dport}/tcp --permanent",
    path => "/usr/bin/",
    before      => Exec['firewall-reload'],
  }

  exec { 'firewall-reload':
    command => "firewall-cmd --reload",
    path    => "/usr/bin/",
    before      => Service['firewalld'],
  }

  service { 'firewalld':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    subscribe  => Exec['firewall-cmd'],
  }

}
