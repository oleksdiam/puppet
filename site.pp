## site.pp ##

# This file (/etc/puppetlabs/puppet/manifests/site.pp) is the main entry point
# used when an agent connects to a master and asks for an updated configuration.
#
# Global objects like filebuckets and resource defaults should go in this file,
# as should the default node definition. (The default node can be omitted
# if you use the console and don't define any other nodes in site.pp. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.)

## Active Configurations ##

# Disable filebucket by default for all File resources:
File { backup => false }

# DEFAULT NODE
# Node definitions in this file are merged with node data from the console. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.

# The default node definition matches any node lacking a more specific node
# definition. If there are no other nodes in this file, classes declared here
# will be included in every node's catalog, *in addition* to any classes
# specified in the console for that node.

node default {
  # This is where you can declare classes for all nodes.
  # Example:
  #   class { 'my_class': }
}
# here is the line 32
node 'pclient.local' {

  java::oracle { 'jdk8':
    ensure        => 'present',
    version_major => '8u162',
    version_minor => 'b12',
    url_hash      => '0da788060d494f5095bf8624735fa2f1',
    java_se       => 'jdk',
  }

  $jdbc = {
    username => 'sonarqube',
    password => 'J0benB0ben',
  }
# here is the line 47 

  class { 'sonarqube':
    arch          => 'linux-x86-64',
    version       => '6.7.1',
    user          => 'sonar',
    group         => 'sonar',
    service       => 'sonar',
    installroot   => '/usr/local',
    home          => '/var/local/sonar',
    download_url  => 'https://sonarsource.bintray.com/Distribution/sonarqube',
    jdbc          => $jdbc,
#    web_java_opts => '-Xmx1024m',
    log_folder    => '/var/local/sonar/logs',
    updatecenter  => 'true',
   # acceptable values of <db_provider> are 'embedded' , 'mysql' , 'psql' , 'oracle'
#    db_provider   => 'embedded'
#    db_host       => 'localhost',
    db_provider   => 'psql',
    db_host       => 'db.local',
#    http_proxy    => {
#      host        => 'proxy.example.com',
#      port        => '8080',
#      ntlm_domain => '',
#      user        => '',
#      password    => '',
#    }
  }
}

node 'jenkins.local' {

  java::oracle { 'jdk8':
    ensure        => 'present',
    version_major => '8u162',
    version_minor => 'b12',
    url_hash      => '0da788060d494f5095bf8624735fa2f1',
    java_se       => 'jdk',
  }

  include maven
  include jenkins
}                         
