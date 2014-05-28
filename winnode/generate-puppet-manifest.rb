domain="example.com"
binLocation="unset"
publicHostname="unset"
brokerHost="unset"
cloudDomain="unset"
sqlServerSAPassword="unset"
externalEthDevice="unset"
internalEthDevice="unset"
publicIp="unset"
gearBaseDir="unset"
gearShell="unset"
gearGecos="unset"
cartridgeBasePath="unset"
platformLogFile="unset"
platformLogLevel="DEBUG"
containerizationPlugin="unset"
rubyDownloadLocation="unset"
rubyInstallLocation="unset"
mcollectiveActivemqServer="unset"
mcollectiveActivemqPort="unset"
mcollectiveActivemqUser="unset"
mcollectiveActivemqPassword="unset"
mcollectivePskPlugin="unset"
sshdCygwinDir="unset"
sshdListenAddress="unset"
sshdPort="unset"
proxy="unset"
skipRuby="unset"
skipCygwin="unset"
skipMCollective="unset"
skipChecks="unset"
skipGlobalEnv="unset"
skipServicesSetup="unset"
skipBinDirCleanup="unset"

File.open('test.rb', 'w') do |f2|
  f2.puts "class vars {
    $powershell = \"C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe\"
    $tmpdir = \"X:/uhuru-origin-puppet\"
    $installerurl = \"http://rpm.uhurucloud.net/origin-rpms/wininstaller/uhuru-openshift-winnode.exe\"
}

class param {
    $domain = \'#{domain}\'
    $binLocation = \'#{binLocation}\'
    $publicHostname = \'#{publicHostname}\'
    $brokerHost = \'#{brokerHost}\'
    $cloudDomain = \'#{cloudDomain}\'
    $sqlServerSAPassword = \'#{sqlServerSAPassword}\'
    $externalEthDevice = \'#{externalEthDevice}\'
    $internalEthDevice = \'#{internalEthDevice}\'
    $publicIp = \'#{publicIp}\'
    $gearBaseDir = \'#{gearBaseDir}\'
    $gearShell = \'#{gearShell}\'
    $gearGecos = \'#{gearGecos}\'
    $cartridgeBasePath = \'#{cartridgeBasePath}\'
    $platformLogFile = \'#{platformLogFile}\'
    $platformLogLevel = \'#{platformLogLevel}\'
    $containerizationPlugin = \'#{containerizationPlugin}\'
    $rubyDownloadLocation = \'#{rubyDownloadLocation}\'
    $rubyInstallLocation = \'#{rubyInstallLocation}\'
    $mcollectiveActivemqServer = \'#{mcollectiveActivemqServer}\'
    $mcollectiveActivemqPort = \'#{mcollectiveActivemqPort}\'
    $mcollectiveActivemqUser = \'#{mcollectiveActivemqUser}\'
    $mcollectiveActivemqPassword = \'#{mcollectiveActivemqPassword}\'
    $mcollectivePskPlugin = \'#{mcollectivePskPlugin}\'
    $sshdCygwinDir = \'#{sshdCygwinDir}\'
    $sshdListenAddress = \'#{sshdListenAddress}\'
    $sshdPort = \'#{sshdPort}\'
    $proxy = \'#{proxy}\'
    $skipRuby = \'#{skipRuby}\'
    $skipCygwin = \'#{skipCygwin}\'
    $skipMCollective = \'#{skipMCollective}\'
    $skipChecks = \'#{skipChecks}\'
    $skipGlobalEnv = \'#{skipGlobalEnv}\'
    $skipServicesSetup = \'#{skipServicesSetup}\'
    $skipBinDirCleanup = \'#{skipBinDirCleanup}\'
}

include param
include vars

file { \'X:\\uhuru-origin-puppet\':
  ensure => \'directory\',
#  group  => \'S-1-5-32-544\',
#  mode   => \'777\',
#  owner  => \'S-1-5-21-2397885826-1833024046-1055597067-500\',
}

exec { \'UhuruOpenshift-download-installer\':
      require => Class[\'param\',\'vars\'],
      command => \"${vars::powershell} iwr ${vars::installerurl} -outfile ${vars::tmpdir}/uhuru-openshift-winnode.exe\",
      creates => \"${vars::tmpdir}/uhuru-openshift-winnode.exe\",
     }

exec { \'UhuruOpenshift-extract-installer\':
      require => Class[\'param\',\'vars\'],
      command => \"${vars::tmpdir}/uhuru-openshift-winnode.exe /T:${vars::tmpdir} /C /Q\",
      creates => \"${vars::tmpdir}/output.zip\",
     }


exec { \'UhuruOpenshift-run-packager\':
      require => Class[\'param\',\'vars\'],
      command => \"${vars::powershell} -ExecutionPolicy bypass ${vars::tmpdir}/package.ps1 bootstrap\",
      creates => \'C:\\openshift\\installer\\oo-cmd.exe\',
     }

exec { \'UhuruOpenshift-run-installer\':
      require => Class[\'param\'],
      command => \"C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -ExecutionPolicy bypass C:\\\\openshift\\\\installer\\\\powershell\\\\Tools\\\\openshift.net\\\\install.ps1 -publicHostname ${param::publicHostname} -brokerHost ${param::brokerHost} -cloudDomain ${param::cloudDomain} -sqlServerSAPassword ${param::sqlServerSAPassword} -externalEthDevice ${param::externalEthDevice} -internalEthDevice ${param::internalEthDevice} -publicIp ${param::publicIp} -gearBaseDir ${param::gearBaseDir} -gearShell ${param::gearShell} -gearGecos ${param::gearGecos} -cartridgeBasePath ${param::cartridgeBasePath} -platformLogFile ${param::platformLogFile} -platformLogLevel ${param::platformLogLevel} -containerizationPlugin ${param::containerizationPlugin} -rubyDownloadLocation ${param::rubyDownloadLocation} -rubyInstallLocation ${param::rubyInstallLocation} -mcollectiveActivemqServer ${param::mcollectiveActivemqServer} -mcollectiveActivemqPort ${param::mcollectiveActivemqPort} -mcollectiveActivemqUser ${param::mcollectiveActivemqUser} -mcollectiveActivemqPassword ${param::mcollectiveActivemqPassword} -mcollectivePskPlugin ${param::mcollectivePskPlugin} -sshdCygwinDir ${param::sshdCygwinDir} -sshdListenAddress ${param::sshdListenAddress} -sshdPort ${param::sshdPort} -proxy ${param::proxy} -skipRuby ${param::skipRuby} -skipCygwin ${param::skipCygwin} -skipMCollective ${param::skipMCollective} -skipChecks ${param::skipChecks} -skipGlobalEnv ${param::skipGlobalEnv} -skipServicesSetup ${param::skipServicesSetup} -skipBinDirCleanup ${param::skipBinDirCleanup}\",
#      creates => \'C:\\openshift\\installer\\powershell\\Tools\\openshift.net\',
     }
"
end