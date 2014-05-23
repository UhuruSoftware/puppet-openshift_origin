class vars {
    $powershell = 'C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe'
    $tmpdir = 'X:/uhuru-origin-puppet'
    $installerurl = "http://rpm.uhurucloud.net/origin-rpms/wininstaller/uhuru-openshift-winnode.exe"
}

class param {
    $domain = 'example.com'
    $binLocation = 'unset'
    $publicHostname = 'unset'
    $brokerHost = 'unset'
    $cloudDomain = 'unset'
    $sqlServerSAPassword = 'unset'
    $externalEthDevice = 'unset'
    $internalEthDevice = 'unset'
    $publicIp = 'unset'
    $gearBaseDir = 'unset'
    $gearShell = 'unset'
    $gearGecos = 'unset'
    $cartridgeBasePath = 'unset'
    $platformLogFile = 'unset'
    $platformLogLevel = 'DEBUG'
    $containerizationPlugin = 'unset'
    $rubyDownloadLocation = 'unset'
    $rubyInstallLocation = 'unset'
    $mcollectiveActivemqServer = 'unset'
    $mcollectiveActivemqPort = 'unset'
    $mcollectiveActivemqUser = 'unset'
    $mcollectiveActivemqPassword = 'unset'
    $mcollectivePskPlugin = 'unset'
    $sshdCygwinDir = 'unset'
    $sshdListenAddress = 'unset'
    $sshdPort = 'unset'
    $proxy = 'unset'
    $skipRuby = 'unset'
    $skipCygwin = 'unset'
    $skipMCollective = 'unset'
    $skipChecks = 'unset'
    $skipGlobalEnv = 'unset'
    $skipServicesSetup = 'unset'
    $skipBinDirCleanup = 'unset'
}

include param
include vars

file { 'X:\uhuru-origin-puppet':
  ensure => 'directory',
#  group  => 'S-1-5-32-544',
#  mode   => '777',
#  owner  => 'S-1-5-21-2397885826-1833024046-1055597067-500',
}

exec { 'UhuruOpenshift-download-installer':
      require => Class['param'],
      command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe iwr "${vars::installerurl}" -outfile "X:\uhuru-origin-puppet\uhuru-openshift-winnode.exe"',
      creates => 'X:\uhuru-origin-puppet\uhuru-openshift-winnode.exe',
     }

exec { 'UhuruOpenshift-extract-installer':
      require => Class['param'],
      command => 'X:\uhuru-origin-puppet\uhuru-openshift-winnode.exe /T:X:\uhuru-origin-puppet\ /C /Q',
      creates => 'X:\uhuru-origin-puppet\output.zip',
     }


exec { 'UhuruOpenshift-run-packager':
      require => Class['param'],
      command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy bypass "X:\uhuru-origin-puppet\package.ps1" bootstrap',
      creates => 'C:\openshift\installer\oo-cmd.exe',
     }

exec { 'UhuruOpenshift-run-installer':
      require => Class['param'],
      command => "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy bypass C:\openshift\installer\powershell\Tools\openshift.net\install.ps1 -publicHostname ${param::publicHostname} -brokerHost ${param::brokerHost} -cloudDomain ${param::cloudDomain} -sqlServerSAPassword ${param::sqlServerSAPassword} -externalEthDevice ${param::externalEthDevice} -internalEthDevice ${param::internalEthDevice} -publicIp ${param::publicIp} -gearBaseDir ${param::gearBaseDir} -gearShell ${param::gearShell} -gearGecos ${param::gearGecos} -cartridgeBasePath ${param::cartridgeBasePath} -platformLogFile ${param::platformLogFile} -platformLogLevel ${param::platformLogLevel} -containerizationPlugin ${param::containerizationPlugin} -rubyDownloadLocation ${param::rubyDownloadLocation} -rubyInstallLocation ${param::rubyInstallLocation} -mcollectiveActivemqServer ${param::mcollectiveActivemqServer} -mcollectiveActivemqPort ${param::mcollectiveActivemqPort} -mcollectiveActivemqUser ${param::mcollectiveActivemqUser} -mcollectiveActivemqPassword ${param::mcollectiveActivemqPassword} -mcollectivePskPlugin ${param::mcollectivePskPlugin} -sshdCygwinDir ${param::sshdCygwinDir} -sshdListenAddress ${param::sshdListenAddress} -sshdPort ${param::sshdPort} -proxy ${param::proxy} -skipRuby ${param::skipRuby} -skipCygwin ${param::skipCygwin} -skipMCollective ${param::skipMCollective} -skipChecks ${param::skipChecks} -skipGlobalEnv ${param::skipGlobalEnv} -skipServicesSetup ${param::skipServicesSetup} -skipBinDirCleanup ${param::skipBinDirCleanup}",
#      creates => 'C:\openshift\installer\powershell\Tools\openshift.net',
     }
