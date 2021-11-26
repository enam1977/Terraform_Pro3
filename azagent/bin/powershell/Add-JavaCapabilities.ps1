[CmdletBinding()]
param()

# Define the JRE/JDK key names.
$jre6KeyName = "Software\JavaSoft\Java Runtime Environment\1.6"
$jre7KeyName = "Software\JavaSoft\Java Runtime Environment\1.7"
$jre8KeyName = "Software\JavaSoft\Java Runtime Environment\1.8"
$jdk6KeyName = "Software\JavaSoft\Java Development Kit\1.6"
$jdk7KeyName = "Software\JavaSoft\Java Development Kit\1.7"
$jdk8KeyName = "Software\JavaSoft\Java Development Kit\1.8"

# JRE/JDK keys for major version >= 9
$jdk9AndGreaterNameOracle = "Software\JavaSoft\JDK"
$jre9AndGreaterNameOracle = "Software\JavaSoft\JRE"
$jre9AndGreaterName = "Software\JavaSoft\Java Runtime Environment"
$jdk9AndGreaterName = "Software\JavaSoft\Java Development Kit"
$minimumMajorVersion9 = 9

# JRE/JDK keys for AdoptOpenJDK
$jdk9AndGreaterNameAdoptOpenJDK = "Software\AdoptOpenJDK\JDK"
$jdk9AndGreaterNameAdoptOpenJRE = "Software\AdoptOpenJDK\JRE"

# These keys required for latest versions of AdoptOpenJDK since they started to publish under Eclipse Foundation name from 24th July 2021 https://blog.adoptopenjdk.net/2021/03/transition-to-eclipse-an-update/ 
$jdk9AndGreaterNameAdoptOpenJDKEclipse = "Software\Eclipse Foundation\JDK"
$jdk9AndGreaterNameAdoptOpenJREEclipse = "Software\Eclipse Foundation\JRE"

# JRE/JDK keys for AdoptOpenJDK with openj9 runtime
$jdk9AndGreaterNameAdoptOpenJDKSemeru = "Software\Semeru\JDK"
$jdk9AndGreaterNameAdoptOpenJRESemeru = "Software\Semeru\JRE"

# JVM subdirectories for AdoptOpenJDK, since it could be ditributed with two different JVM versions, which are located in different subdirectories inside version directory
$jvmHotSpot = "hotspot\MSI"
$jvmOpenj9 = "openj9\MSI"

# Check for JRE.
$latestJre = $null
$null = Add-CapabilityFromRegistry -Name 'java_6' -Hive 'LocalMachine' -View 'Registry32' -KeyName $jre6KeyName -ValueName 'JavaHome' -Value ([ref]$latestJre)
$null = Add-CapabilityFromRegistry -Name 'java_7' -Hive 'LocalMachine' -View 'Registry32' -KeyName $jre7KeyName -ValueName 'JavaHome' -Value ([ref]$latestJre)
$null = Add-CapabilityFromRegistry -Name 'java_8' -Hive 'LocalMachine' -View 'Registry32' -KeyName $jre8KeyName -ValueName 'JavaHome' -Value ([ref]$latestJre)
$null = Add-CapabilityFromRegistry -Name 'java_6_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jre6KeyName -ValueName 'JavaHome' -Value ([ref]$latestJre)
$null = Add-CapabilityFromRegistry -Name 'java_7_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jre7KeyName -ValueName 'JavaHome' -Value ([ref]$latestJre)
$null = Add-CapabilityFromRegistry -Name 'java_8_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jre8KeyName -ValueName 'JavaHome' -Value ([ref]$latestJre)

if  (-not (Test-Path env:DISABLE_JAVA_CAPABILITY_HIGHER_THAN_9)) {
    try {
        $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'java_' -Hive 'LocalMachine' -View 'Registry32' -KeyName $jre9AndGreaterName -ValueName 'JavaHome' -Value ([ref]$latestJre) -MinimumMajorVersion $minimumMajorVersion9
        $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'java_' -Hive 'LocalMachine' -View 'Registry32' -KeyName $jre9AndGreaterNameOracle -ValueName 'JavaHome' -Value ([ref]$latestJre) -MinimumMajorVersion $minimumMajorVersion9
        $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'java_' -PostfixName '_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jre9AndGreaterName -ValueName 'JavaHome' -Value ([ref]$latestJre) -MinimumMajorVersion $minimumMajorVersion9
        $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'java_' -PostfixName '_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jre9AndGreaterNameOracle -ValueName 'JavaHome' -Value ([ref]$latestJre) -MinimumMajorVersion $minimumMajorVersion9
    } catch {
        Write-Host "An error occured while trying to check if there are JRE >= 9"
        Write-Host $_
    }
}

# Check default reg keys for AdoptOpenJDK in case we didn't find JRE in JavaSoft
if (-not $latestJre) {
    # AdoptOpenJDK section
    $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'java_' -PostfixName '_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jdk9AndGreaterNameAdoptOpenJRE -ValueName 'Path' -Value ([ref]$latestJre) -VersionSubdirectory $jvmHotSpot -MinimumMajorVersion $minimumMajorVersion9
    $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'java_' -PostfixName '_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jdk9AndGreaterNameAdoptOpenJRE -ValueName 'Path' -Value ([ref]$latestJre) -VersionSubdirectory $jvmOpenj9 -MinimumMajorVersion $minimumMajorVersion9
    $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'java_' -PostfixName '_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jdk9AndGreaterNameAdoptOpenJREEclipse -ValueName 'Path' -Value ([ref]$latestJre) -VersionSubdirectory $jvmHotSpot -MinimumMajorVersion $minimumMajorVersion9
    $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'java_' -PostfixName '_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jdk9AndGreaterNameAdoptOpenJRESemeru -ValueName 'Path' -Value ([ref]$latestJre) -VersionSubdirectory $jvmOpenj9 -MinimumMajorVersion $minimumMajorVersion9
}

if ($latestJre) {
    # Favor x64.
    Write-Capability -Name 'java' -Value $latestJre
}

# Check for JDK.
$latestJdk = $null
$null = Add-CapabilityFromRegistry -Name 'jdk_6' -Hive 'LocalMachine' -View 'Registry32' -KeyName $jdk6KeyName -ValueName 'JavaHome' -Value ([ref]$latestJdk)
$null = Add-CapabilityFromRegistry -Name 'jdk_7' -Hive 'LocalMachine' -View 'Registry32' -KeyName $jdk7KeyName -ValueName 'JavaHome' -Value ([ref]$latestJdk)
$null = Add-CapabilityFromRegistry -Name 'jdk_8' -Hive 'LocalMachine' -View 'Registry32' -KeyName $jdk8KeyName -ValueName 'JavaHome' -Value ([ref]$latestJdk)
$null = Add-CapabilityFromRegistry -Name 'jdk_6_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jdk6KeyName -ValueName 'JavaHome' -Value ([ref]$latestJdk)
$null = Add-CapabilityFromRegistry -Name 'jdk_7_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jdk7KeyName -ValueName 'JavaHome' -Value ([ref]$latestJdk)
$null = Add-CapabilityFromRegistry -Name 'jdk_8_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jdk8KeyName -ValueName 'JavaHome' -Value ([ref]$latestJdk)

if  (-not (Test-Path env:DISABLE_JAVA_CAPABILITY_HIGHER_THAN_9)) {
    try {
        $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'jdk_' -Hive 'LocalMachine' -View 'Registry32' -KeyName $jdk9AndGreaterName -ValueName 'JavaHome' -Value ([ref]$latestJdk) -MinimumMajorVersion $minimumMajorVersion9
        $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'jdk_' -Hive 'LocalMachine' -View 'Registry32' -KeyName $jdk9AndGreaterNameOracle -ValueName 'JavaHome' -Value ([ref]$latestJdk) -MinimumMajorVersion $minimumMajorVersion9
        $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'jdk_' -PostfixName '_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jdk9AndGreaterName -ValueName 'JavaHome' -Value ([ref]$latestJdk) -MinimumMajorVersion $minimumMajorVersion9
        $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'jdk_' -PostfixName '_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jdk9AndGreaterNameOracle -ValueName 'JavaHome' -Value ([ref]$latestJdk) -MinimumMajorVersion $minimumMajorVersion9
    } catch {
        Write-Host "An error occured while trying to check if there are JDK >= 9"
        Write-Host $_
    }
}

# Check default reg keys for AdoptOpenJDK in case we didn't find JDK in JavaSoft
if (-not $latestJdk) {
    # AdoptOpenJDK section
    $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'jdk_' -PostfixName '_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jdk9AndGreaterNameAdoptOpenJDK -ValueName 'Path' -Value ([ref]$latestJdk) -VersionSubdirectory $jvmHotSpot -MinimumMajorVersion $minimumMajorVersion9
    $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'jdk_' -PostfixName '_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jdk9AndGreaterNameAdoptOpenJDK -ValueName 'Path' -Value ([ref]$latestJdk) -VersionSubdirectory $jvmOpenj9 -MinimumMajorVersion $minimumMajorVersion9
    $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'jdk_' -PostfixName '_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jdk9AndGreaterNameAdoptOpenJDKEclipse -ValueName 'Path' -Value ([ref]$latestJdk) -VersionSubdirectory $jvmHotSpot -MinimumMajorVersion $minimumMajorVersion9
    $null = Add-CapabilityFromRegistryWithLastVersionAvailable -PrefixName 'jdk_' -PostfixName '_x64' -Hive 'LocalMachine' -View 'Registry64' -KeyName $jdk9AndGreaterNameAdoptOpenJDKSemeru -ValueName 'Path' -Value ([ref]$latestJdk) -VersionSubdirectory $jvmOpenj9 -MinimumMajorVersion $minimumMajorVersion9
}

if ($latestJdk) {
    # Favor x64.
    Write-Capability -Name 'jdk' -Value $latestJdk

    if (!($latestJre)) {
        Write-Capability -Name 'java' -Value $latestJdk
    }
}

# SIG # Begin signature block
# MIIjngYJKoZIhvcNAQcCoIIjjzCCI4sCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCApOtIdNoBDE+gE
# 632igjDdNRPifhcmDZN6etVKN6PAH6CCDYEwggX/MIID56ADAgECAhMzAAAB32vw
# LpKnSrTQAAAAAAHfMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMjAxMjE1MjEzMTQ1WhcNMjExMjAyMjEzMTQ1WjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQC2uxlZEACjqfHkuFyoCwfL25ofI9DZWKt4wEj3JBQ48GPt1UsDv834CcoUUPMn
# s/6CtPoaQ4Thy/kbOOg/zJAnrJeiMQqRe2Lsdb/NSI2gXXX9lad1/yPUDOXo4GNw
# PjXq1JZi+HZV91bUr6ZjzePj1g+bepsqd/HC1XScj0fT3aAxLRykJSzExEBmU9eS
# yuOwUuq+CriudQtWGMdJU650v/KmzfM46Y6lo/MCnnpvz3zEL7PMdUdwqj/nYhGG
# 3UVILxX7tAdMbz7LN+6WOIpT1A41rwaoOVnv+8Ua94HwhjZmu1S73yeV7RZZNxoh
# EegJi9YYssXa7UZUUkCCA+KnAgMBAAGjggF+MIIBejAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQUOPbML8IdkNGtCfMmVPtvI6VZ8+Mw
# UAYDVR0RBEkwR6RFMEMxKTAnBgNVBAsTIE1pY3Jvc29mdCBPcGVyYXRpb25zIFB1
# ZXJ0byBSaWNvMRYwFAYDVQQFEw0yMzAwMTIrNDYzMDA5MB8GA1UdIwQYMBaAFEhu
# ZOVQBdOCqhc3NyK1bajKdQKVMFQGA1UdHwRNMEswSaBHoEWGQ2h0dHA6Ly93d3cu
# bWljcm9zb2Z0LmNvbS9wa2lvcHMvY3JsL01pY0NvZFNpZ1BDQTIwMTFfMjAxMS0w
# Ny0wOC5jcmwwYQYIKwYBBQUHAQEEVTBTMFEGCCsGAQUFBzAChkVodHRwOi8vd3d3
# Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NlcnRzL01pY0NvZFNpZ1BDQTIwMTFfMjAx
# MS0wNy0wOC5jcnQwDAYDVR0TAQH/BAIwADANBgkqhkiG9w0BAQsFAAOCAgEAnnqH
# tDyYUFaVAkvAK0eqq6nhoL95SZQu3RnpZ7tdQ89QR3++7A+4hrr7V4xxmkB5BObS
# 0YK+MALE02atjwWgPdpYQ68WdLGroJZHkbZdgERG+7tETFl3aKF4KpoSaGOskZXp
# TPnCaMo2PXoAMVMGpsQEQswimZq3IQ3nRQfBlJ0PoMMcN/+Pks8ZTL1BoPYsJpok
# t6cql59q6CypZYIwgyJ892HpttybHKg1ZtQLUlSXccRMlugPgEcNZJagPEgPYni4
# b11snjRAgf0dyQ0zI9aLXqTxWUU5pCIFiPT0b2wsxzRqCtyGqpkGM8P9GazO8eao
# mVItCYBcJSByBx/pS0cSYwBBHAZxJODUqxSXoSGDvmTfqUJXntnWkL4okok1FiCD
# Z4jpyXOQunb6egIXvkgQ7jb2uO26Ow0m8RwleDvhOMrnHsupiOPbozKroSa6paFt
# VSh89abUSooR8QdZciemmoFhcWkEwFg4spzvYNP4nIs193261WyTaRMZoceGun7G
# CT2Rl653uUj+F+g94c63AhzSq4khdL4HlFIP2ePv29smfUnHtGq6yYFDLnT0q/Y+
# Di3jwloF8EWkkHRtSuXlFUbTmwr/lDDgbpZiKhLS7CBTDj32I0L5i532+uHczw82
# oZDmYmYmIUSMbZOgS65h797rj5JJ6OkeEUJoAVwwggd6MIIFYqADAgECAgphDpDS
# AAAAAAADMA0GCSqGSIb3DQEBCwUAMIGIMQswCQYDVQQGEwJVUzETMBEGA1UECBMK
# V2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0
# IENvcnBvcmF0aW9uMTIwMAYDVQQDEylNaWNyb3NvZnQgUm9vdCBDZXJ0aWZpY2F0
# ZSBBdXRob3JpdHkgMjAxMTAeFw0xMTA3MDgyMDU5MDlaFw0yNjA3MDgyMTA5MDla
# MH4xCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdS
# ZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMT
# H01pY3Jvc29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTEwggIiMA0GCSqGSIb3DQEB
# AQUAA4ICDwAwggIKAoICAQCr8PpyEBwurdhuqoIQTTS68rZYIZ9CGypr6VpQqrgG
# OBoESbp/wwwe3TdrxhLYC/A4wpkGsMg51QEUMULTiQ15ZId+lGAkbK+eSZzpaF7S
# 35tTsgosw6/ZqSuuegmv15ZZymAaBelmdugyUiYSL+erCFDPs0S3XdjELgN1q2jz
# y23zOlyhFvRGuuA4ZKxuZDV4pqBjDy3TQJP4494HDdVceaVJKecNvqATd76UPe/7
# 4ytaEB9NViiienLgEjq3SV7Y7e1DkYPZe7J7hhvZPrGMXeiJT4Qa8qEvWeSQOy2u
# M1jFtz7+MtOzAz2xsq+SOH7SnYAs9U5WkSE1JcM5bmR/U7qcD60ZI4TL9LoDho33
# X/DQUr+MlIe8wCF0JV8YKLbMJyg4JZg5SjbPfLGSrhwjp6lm7GEfauEoSZ1fiOIl
# XdMhSz5SxLVXPyQD8NF6Wy/VI+NwXQ9RRnez+ADhvKwCgl/bwBWzvRvUVUvnOaEP
# 6SNJvBi4RHxF5MHDcnrgcuck379GmcXvwhxX24ON7E1JMKerjt/sW5+v/N2wZuLB
# l4F77dbtS+dJKacTKKanfWeA5opieF+yL4TXV5xcv3coKPHtbcMojyyPQDdPweGF
# RInECUzF1KVDL3SV9274eCBYLBNdYJWaPk8zhNqwiBfenk70lrC8RqBsmNLg1oiM
# CwIDAQABo4IB7TCCAekwEAYJKwYBBAGCNxUBBAMCAQAwHQYDVR0OBBYEFEhuZOVQ
# BdOCqhc3NyK1bajKdQKVMBkGCSsGAQQBgjcUAgQMHgoAUwB1AGIAQwBBMAsGA1Ud
# DwQEAwIBhjAPBgNVHRMBAf8EBTADAQH/MB8GA1UdIwQYMBaAFHItOgIxkEO5FAVO
# 4eqnxzHRI4k0MFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9jcmwubWljcm9zb2Z0
# LmNvbS9wa2kvY3JsL3Byb2R1Y3RzL01pY1Jvb0NlckF1dDIwMTFfMjAxMV8wM18y
# Mi5jcmwwXgYIKwYBBQUHAQEEUjBQME4GCCsGAQUFBzAChkJodHRwOi8vd3d3Lm1p
# Y3Jvc29mdC5jb20vcGtpL2NlcnRzL01pY1Jvb0NlckF1dDIwMTFfMjAxMV8wM18y
# Mi5jcnQwgZ8GA1UdIASBlzCBlDCBkQYJKwYBBAGCNy4DMIGDMD8GCCsGAQUFBwIB
# FjNodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2RvY3MvcHJpbWFyeWNw
# cy5odG0wQAYIKwYBBQUHAgIwNB4yIB0ATABlAGcAYQBsAF8AcABvAGwAaQBjAHkA
# XwBzAHQAYQB0AGUAbQBlAG4AdAAuIB0wDQYJKoZIhvcNAQELBQADggIBAGfyhqWY
# 4FR5Gi7T2HRnIpsLlhHhY5KZQpZ90nkMkMFlXy4sPvjDctFtg/6+P+gKyju/R6mj
# 82nbY78iNaWXXWWEkH2LRlBV2AySfNIaSxzzPEKLUtCw/WvjPgcuKZvmPRul1LUd
# d5Q54ulkyUQ9eHoj8xN9ppB0g430yyYCRirCihC7pKkFDJvtaPpoLpWgKj8qa1hJ
# Yx8JaW5amJbkg/TAj/NGK978O9C9Ne9uJa7lryft0N3zDq+ZKJeYTQ49C/IIidYf
# wzIY4vDFLc5bnrRJOQrGCsLGra7lstnbFYhRRVg4MnEnGn+x9Cf43iw6IGmYslmJ
# aG5vp7d0w0AFBqYBKig+gj8TTWYLwLNN9eGPfxxvFX1Fp3blQCplo8NdUmKGwx1j
# NpeG39rz+PIWoZon4c2ll9DuXWNB41sHnIc+BncG0QaxdR8UvmFhtfDcxhsEvt9B
# xw4o7t5lL+yX9qFcltgA1qFGvVnzl6UJS0gQmYAf0AApxbGbpT9Fdx41xtKiop96
# eiL6SJUfq/tHI4D1nvi/a7dLl+LrdXga7Oo3mXkYS//WsyNodeav+vyL6wuA6mk7
# r/ww7QRMjt/fdW1jkT3RnVZOT7+AVyKheBEyIXrvQQqxP/uozKRdwaGIm1dxVk5I
# RcBCyZt2WwqASGv9eZ/BvW1taslScxMNelDNMYIVczCCFW8CAQEwgZUwfjELMAkG
# A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQx
# HjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEoMCYGA1UEAxMfTWljcm9z
# b2Z0IENvZGUgU2lnbmluZyBQQ0EgMjAxMQITMwAAAd9r8C6Sp0q00AAAAAAB3zAN
# BglghkgBZQMEAgEFAKCBrjAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgor
# BgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQg9C4um2qB
# JNy6RBRbU6G26/CeAQV4lwNFKq+WJWTYFYgwQgYKKwYBBAGCNwIBDDE0MDKgFIAS
# AE0AaQBjAHIAbwBzAG8AZgB0oRqAGGh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbTAN
# BgkqhkiG9w0BAQEFAASCAQARghmh4NOaxJq525q8uxHjQIGnCCcvr5gghBYzeGdQ
# +YwUPXVAjWsm2uwz95kGDCsHI+/26b9DF0eXUZlURUHiUre4UhXJKL4U1l/sf6Xt
# RqUZgeUVV1Izi7GK8xSHjAi+MQbE3oPTZH7qddYHb1VacFHEgl9uP7o7AO9I0rSs
# r3MmLjy2+die0/ThWr35MHV0xv67c/aBtOi75+/FqhTpUfG7Uz8Aq/fTxoqVhbyM
# hpxXbqYTkIzUIgobuNU8EmjREGnQCXGh8G/pQLIJsVbh3K18/zrG2D29ZTNPEJRF
# dG/1Bg42Tc68rRpsTgM2Ct7bmkeHYhqtS8fafE3+UpD3oYIS/TCCEvkGCisGAQQB
# gjcDAwExghLpMIIS5QYJKoZIhvcNAQcCoIIS1jCCEtICAQMxDzANBglghkgBZQME
# AgEFADCCAVgGCyqGSIb3DQEJEAEEoIIBRwSCAUMwggE/AgEBBgorBgEEAYRZCgMB
# MDEwDQYJYIZIAWUDBAIBBQAEILNXBvZkgl+1MOv0/IroBDUWFkCFNdUvNtCML9CN
# /8vxAgZhgvIa3S0YEjIwMjExMTA4MTMxMTUwLjY5WjAEgAIB9KCB2KSB1TCB0jEL
# MAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1v
# bmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEtMCsGA1UECxMkTWlj
# cm9zb2Z0IElyZWxhbmQgT3BlcmF0aW9ucyBMaW1pdGVkMSYwJAYDVQQLEx1UaGFs
# ZXMgVFNTIEVTTjo4NkRGLTRCQkMtOTMzNTElMCMGA1UEAxMcTWljcm9zb2Z0IFRp
# bWUtU3RhbXAgU2VydmljZaCCDk0wggT5MIID4aADAgECAhMzAAABPs7Kd1LF9zQr
# AAAAAAE+MA0GCSqGSIb3DQEBCwUAMHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpX
# YXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQg
# Q29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAy
# MDEwMB4XDTIwMTAxNTE3MjgyNVoXDTIyMDExMjE3MjgyNVowgdIxCzAJBgNVBAYT
# AlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYD
# VQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xLTArBgNVBAsTJE1pY3Jvc29mdCBJ
# cmVsYW5kIE9wZXJhdGlvbnMgTGltaXRlZDEmMCQGA1UECxMdVGhhbGVzIFRTUyBF
# U046ODZERi00QkJDLTkzMzUxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1w
# IFNlcnZpY2UwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC8VMTIPNl+
# nCzjTiBILSS3hVLJf+9rHA5+uLz2BB3G99A2+9ABF5spHemWofPRkdlb5uYXHIa1
# OH3PDbQtJ2kxxZgMVzWvM+4m9M0CcOQrJA/5OqtbuP+UOUItuqLy5ujgSpKmQetr
# Rm3XmPav8gkZlu7dBpFjqpgxnHGSTDhjm5sDBXcTWn5M3MWDyfOAn2TAQzjG9kB/
# 02EeEzYr+PHT3bGYrHIV+nRfS1uhj13U7KF0JeXyyk6KATfaDzMfXZjY1dN8jjXj
# UtBT710o4pDtgUXWTCh+4YbDExTQKwOKY4NaCvpUVVw0N3a1Bsa5uB18sEYQF+N7
# Q/Kg45cQ7WbhAgMBAAGjggEbMIIBFzAdBgNVHQ4EFgQUk1rznfi70GIta/C1tlQO
# toaI/XswHwYDVR0jBBgwFoAU1WM6XIoxkPNDe3xGG8UzaFqFbVUwVgYDVR0fBE8w
# TTBLoEmgR4ZFaHR0cDovL2NybC5taWNyb3NvZnQuY29tL3BraS9jcmwvcHJvZHVj
# dHMvTWljVGltU3RhUENBXzIwMTAtMDctMDEuY3JsMFoGCCsGAQUFBwEBBE4wTDBK
# BggrBgEFBQcwAoY+aHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraS9jZXJ0cy9N
# aWNUaW1TdGFQQ0FfMjAxMC0wNy0wMS5jcnQwDAYDVR0TAQH/BAIwADATBgNVHSUE
# DDAKBggrBgEFBQcDCDANBgkqhkiG9w0BAQsFAAOCAQEAprP5EX1an4aSuRWPpxjl
# 2MJ1V6kkXK58AEnWoqUJZeE6hgBwHvDtnHNELhnaJjhtz1BT3exrZgPCFDAU96p8
# pl9ZKSaty6zj1AH0QY9z0XAiB8FArYAm2FpgTKxNrBLjR/rJzrD/Jui0ByWoUCv4
# E8O3TMZmgTG8ZzxmlUBmm9LJdvMYu4q2bwr5HvdULgNSnixEVyTULHwgu9h1hI1i
# o5HKHQbCLe/gdabDoe61p8U50WNopARxKyfRI0t9jbmo6qe7oMv40CjvPeoPR4EM
# hKKVahvl2WUNw41+y731QS06ett2Xb3bIY0jLGKWkjxcY2AZxnEo3pWosHEC4qVY
# 5jCCBnEwggRZoAMCAQICCmEJgSoAAAAAAAIwDQYJKoZIhvcNAQELBQAwgYgxCzAJ
# BgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25k
# MR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xMjAwBgNVBAMTKU1pY3Jv
# c29mdCBSb290IENlcnRpZmljYXRlIEF1dGhvcml0eSAyMDEwMB4XDTEwMDcwMTIx
# MzY1NVoXDTI1MDcwMTIxNDY1NVowfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldh
# c2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBD
# b3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIw
# MTAwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCpHQ28dxGKOiDs/BOX
# 9fp/aZRrdFQQ1aUKAIKF++18aEssX8XD5WHCdrc+Zitb8BVTJwQxH0EbGpUdzgkT
# jnxhMFmxMEQP8WCIhFRDDNdNuDgIs0Ldk6zWczBXJoKjRQ3Q6vVHgc2/JGAyWGBG
# 8lhHhjKEHnRhZ5FfgVSxz5NMksHEpl3RYRNuKMYa+YaAu99h/EbBJx0kZxJyGiGK
# r0tkiVBisV39dx898Fd1rL2KQk1AUdEPnAY+Z3/1ZsADlkR+79BL/W7lmsqxqPJ6
# Kgox8NpOBpG2iAg16HgcsOmZzTznL0S6p/TcZL2kAcEgCZN4zfy8wMlEXV4WnAEF
# TyJNAgMBAAGjggHmMIIB4jAQBgkrBgEEAYI3FQEEAwIBADAdBgNVHQ4EFgQU1WM6
# XIoxkPNDe3xGG8UzaFqFbVUwGQYJKwYBBAGCNxQCBAweCgBTAHUAYgBDAEEwCwYD
# VR0PBAQDAgGGMA8GA1UdEwEB/wQFMAMBAf8wHwYDVR0jBBgwFoAU1fZWy4/oolxi
# aNE9lJBb186aGMQwVgYDVR0fBE8wTTBLoEmgR4ZFaHR0cDovL2NybC5taWNyb3Nv
# ZnQuY29tL3BraS9jcmwvcHJvZHVjdHMvTWljUm9vQ2VyQXV0XzIwMTAtMDYtMjMu
# Y3JsMFoGCCsGAQUFBwEBBE4wTDBKBggrBgEFBQcwAoY+aHR0cDovL3d3dy5taWNy
# b3NvZnQuY29tL3BraS9jZXJ0cy9NaWNSb29DZXJBdXRfMjAxMC0wNi0yMy5jcnQw
# gaAGA1UdIAEB/wSBlTCBkjCBjwYJKwYBBAGCNy4DMIGBMD0GCCsGAQUFBwIBFjFo
# dHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vUEtJL2RvY3MvQ1BTL2RlZmF1bHQuaHRt
# MEAGCCsGAQUFBwICMDQeMiAdAEwAZQBnAGEAbABfAFAAbwBsAGkAYwB5AF8AUwB0
# AGEAdABlAG0AZQBuAHQALiAdMA0GCSqGSIb3DQEBCwUAA4ICAQAH5ohRDeLG4Jg/
# gXEDPZ2joSFvs+umzPUxvs8F4qn++ldtGTCzwsVmyWrf9efweL3HqJ4l4/m87WtU
# VwgrUYJEEvu5U4zM9GASinbMQEBBm9xcF/9c+V4XNZgkVkt070IQyK+/f8Z/8jd9
# Wj8c8pl5SpFSAK84Dxf1L3mBZdmptWvkx872ynoAb0swRCQiPM/tA6WWj1kpvLb9
# BOFwnzJKJ/1Vry/+tuWOM7tiX5rbV0Dp8c6ZZpCM/2pif93FSguRJuI57BlKcWOd
# eyFtw5yjojz6f32WapB4pm3S4Zz5Hfw42JT0xqUKloakvZ4argRCg7i1gJsiOCC1
# JeVk7Pf0v35jWSUPei45V3aicaoGig+JFrphpxHLmtgOR5qAxdDNp9DvfYPw4Ttx
# Cd9ddJgiCGHasFAeb73x4QDf5zEHpJM692VHeOj4qEir995yfmFrb3epgcunCaw5
# u+zGy9iCtHLNHfS4hQEegPsbiSpUObJb2sgNVZl6h3M7COaYLeqN4DMuEin1wC9U
# JyH3yKxO2ii4sanblrKnQqLJzxlBTeCG+SqaoxFmMNO7dDJL32N79ZmKLxvHIa9Z
# ta7cRDyXUHHXodLFVeNp3lfB0d4wwP3M5k37Db9dT+mdHhk4L7zPWAUu7w2gUDXa
# 7wknHNWzfjUeCLraNtvTX4/edIhJEqGCAtcwggJAAgEBMIIBAKGB2KSB1TCB0jEL
# MAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1v
# bmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEtMCsGA1UECxMkTWlj
# cm9zb2Z0IElyZWxhbmQgT3BlcmF0aW9ucyBMaW1pdGVkMSYwJAYDVQQLEx1UaGFs
# ZXMgVFNTIEVTTjo4NkRGLTRCQkMtOTMzNTElMCMGA1UEAxMcTWljcm9zb2Z0IFRp
# bWUtU3RhbXAgU2VydmljZaIjCgEBMAcGBSsOAwIaAxUAoEwV6PTGMJOMKTWxN1Mp
# r5PMkNSggYMwgYCkfjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3Rv
# bjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0
# aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDANBgkq
# hkiG9w0BAQUFAAIFAOUzXxUwIhgPMjAyMTExMDgxNjMyMjFaGA8yMDIxMTEwOTE2
# MzIyMVowdzA9BgorBgEEAYRZCgQBMS8wLTAKAgUA5TNfFQIBADAKAgEAAgILowIB
# /zAHAgEAAgIRgDAKAgUA5TSwlQIBADA2BgorBgEEAYRZCgQCMSgwJjAMBgorBgEE
# AYRZCgMCoAowCAIBAAIDB6EgoQowCAIBAAIDAYagMA0GCSqGSIb3DQEBBQUAA4GB
# AHU+DOuCPaAL/GycTmSrN47LCqWRlpvdvLoKOjEccp0nzVuTVD4d1wT29xNtpgYK
# RDxE+RejIP8Azywnb8DurD5N6PchSXo8DHCakBjmk+vGP75uWP2tHcZY4v7wl7CF
# hhFnsuoiSRDsxYFkwMfQ9IxgDrg4yH3sxjrYmN06PowVMYIDDTCCAwkCAQEwgZMw
# fDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1Jl
# ZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMd
# TWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTACEzMAAAE+zsp3UsX3NCsAAAAA
# AT4wDQYJYIZIAWUDBAIBBQCgggFKMBoGCSqGSIb3DQEJAzENBgsqhkiG9w0BCRAB
# BDAvBgkqhkiG9w0BCQQxIgQgxr9OTSXWceE2vlNm8tetX/Uyi5fWQpxo5InsVe5U
# Zb0wgfoGCyqGSIb3DQEJEAIvMYHqMIHnMIHkMIG9BCCL686Nqo1O8o5ka63j0deu
# q3BSPZkKdU66sHB+BDGbEzCBmDCBgKR+MHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQI
# EwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3Nv
# ZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBD
# QSAyMDEwAhMzAAABPs7Kd1LF9zQrAAAAAAE+MCIEIPrUdIzccoc9CMstXiCMkbO0
# mUs3UcWJc9guqBCWdWh0MA0GCSqGSIb3DQEBCwUABIIBAJb2xUj31/su+2sH7AS/
# /5VtVP/MnHoMhKHLJ2ePxiZaUBaPYy1CN+nXzqaCbckXWKzIPumwcAHA0UbstR6z
# Ak5P9RPAImUXL7+BaDjRlqNvigE/arcCgNQHHL9HkW/6AQDVyTEaBgWmCT8JBkSu
# o7iYmARMlmI4Zvr0yAVahkPADjc/kHcZJ6vcV5SGGDtZD3jUU/0PvSuFdTOVLaSe
# 7MwXqTM8XJC+rPufPRPT6dLS5gMTouCA4A5BwQGYf9eAw4WUoku2KO4vJll5mbqn
# 6DdzNKmhMdOhv9cUhrKejDJi6Wh+lpbZVJ+2MDGzx+K38S9vzc0QEqb2BoEvYOvw
# o7g=
# SIG # End signature block
