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
  ->
  exec {'install basic plugins':
    command => '/bin/unzip -j -u /home/gerrit/gerrit.war \'WEB-INF/plugins/*\'',
    cwd => '/home/gerrit/site/plugins/',
  }
  ->
  file {'/home/gerrit/site/plugins/gitiles.jar':
    source => 'https://gerrit-ci.gerritforge.com/view/Plugins-stable-2.15/job/plugin-gitiles-bazel-stable-2.15/lastSuccessfulBuild/artifact/bazel-genfiles/plugins/gitiles/gitiles.jar',
  }


  exec {'init gerrit':
    command => '/usr/bin/java -jar /home/gerrit/gerrit.war init -d /home/gerrit/site/',
    user => 'gerrit',
    require => [Package['java-1.8.0-openjdk-headless'],
                File['/home/gerrit/gerrit.war']],
    creates => '/home/gerrit/site',
  }
}
