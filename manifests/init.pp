class gerrit($backup_user) {
  package {['java-1.8.0-openjdk-headless', 'git']:}

  user {'gerrit':
    ensure => present,
    managehome => true,
  }
  ->
  file {'/home/gerrit/gerrit.war':
    source => 'https://gerrit-releases.storage.googleapis.com/gerrit-2.16.2.war',
    notify => Service['gerrit'],
  }
  ->
  exec {'init gerrit':
    command => '/usr/bin/java -jar /home/gerrit/gerrit.war init -d /home/gerrit/site/',
    user => 'gerrit',
    require => [Package['java-1.8.0-openjdk-headless'],
                File['/home/gerrit/gerrit.war']],
    creates => '/home/gerrit/site',
  }
  ->
  exec {'install basic plugins':
    command => '/bin/unzip -j -u /home/gerrit/gerrit.war \'WEB-INF/plugins/*\'',
    cwd => '/home/gerrit/site/plugins/',
  }
  ->
  file {'/home/gerrit/site/plugins/gitiles.jar':
    source => 'https://gerrit-ci.gerritforge.com/view/Plugins-stable-2.16/job/plugin-gitiles-bazel-master-stable-2.16/lastSuccessfulBuild/artifact/bazel-genfiles/plugins/gitiles/gitiles.jar',
  }

  file {'/etc/systemd/system/gerrit.service':
    source => 'puppet:///modules/gerrit/gerrit.service',
  }
  ~>
  exec {'reload systemd daemon':
    command => '/bin/systemctl daemon-reload',
  }

  file {'/etc/cron.daily/gerrit-backup':
    content => epp('gerrit/backup', {'backup_user' => $backup_user,}),
    mode => '0744',
  }
}
