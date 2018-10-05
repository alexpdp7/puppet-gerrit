class gerrit {
  package {'java-1.8.0-openjdk-headless':}

  user {'gerrit':
    ensure => present,
    managehome => true,
  }
  ->
  file {'/home/gerrit/gerrit.war':
    source => 'https://gerrit-releases.storage.googleapis.com/gerrit-2.15.4.war',
  }
}
