class gerrit {
  package {['java-1.8.0-openjdk-headless', 'git']:}

  user {'gerrit':
    ensure => present,
    managehome => true,
  }
  ->
  file {'/home/gerrit/gerrit.war':
    source => 'https://gerrit-releases.storage.googleapis.com/gerrit-2.15.4.war',
  }

  exec {'init gerrit':
    command => '/usr/bin/java -jar /home/gerrit/gerrit.war init -d /home/gerrit/site/',
    user => 'gerrit',
    require => [Package['java-1.8.0-openjdk-headless'],
                File['/home/gerrit/gerrit.war']],
    creates => '/home/gerrit/site',
  }
}
