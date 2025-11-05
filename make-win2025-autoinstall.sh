#!/usr/bin/env bash
set -e

ISO="/var/lib/vz/template/iso/26100.1742.240906-0331.ge_release_svc_refresh_SERVER_EVAL_x64FRE_en-us.iso"
OUT="/var/lib/vz/template/iso/win2025-autounattend.iso"
WORK="/root/win-autoinstall"
VIRTIO_URL="https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso"

ADMIN_PASS="0okm)OKM#13"
TIMEZONE="India Standard Time"

mkdir -p "$WORK"
cd "$WORK"

# Download VirtIO drivers
if [ ! -f virtio-win.iso ]; then
  echo "[+] Downloading VirtIO drivers..."
  curl -L -o virtio-win.iso "$VIRTIO_URL"
fi

# Create Autounattend.xml
cat > autounattend.xml <<EOF
<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">
  <settings pass="windowsPE">
    <component name="Microsoft-Windows-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <ImageInstall>
        <OSImage>
          <InstallFrom>
            <MetaData wcm:action="add">
              <Key>/IMAGE/NAME</Key>
              <Value>Windows Server 2025 SERVERSTANDARD</Value>
            </MetaData>
          </InstallFrom>
          <InstallTo>
            <DiskID>0</DiskID>
            <PartitionID>1</PartitionID>
          </InstallTo>
          <InstallToAvailablePartition>true</InstallToAvailablePartition>
          <WillShowUI>OnError</WillShowUI>
        </OSImage>
      </ImageInstall>
      <UserData>
        <AcceptEula>true</AcceptEula>
        <FullName>Administrator</FullName>
        <Organization>Automated</Organization>
        <ProductKey></ProductKey>
      </UserData>
      <Display>
        <ColorDepth>32</ColorDepth>
        <HorizontalResolution>1024</HorizontalResolution>
        <VerticalResolution>768</VerticalResolution>
      </Display>
    </component>
  </settings>

  <settings pass="specialize">
    <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State">
      <ComputerName>WIN-SERVER</ComputerName>
      <TimeZone>${TIMEZONE}</TimeZone>
    </component>
  </settings>

  <settings pass="oobeSystem">
    <component name="Microsoft-Windows-International-Core" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State">
      <InputLocale>en-US</InputLocale>
      <SystemLocale>en-US</SystemLocale>
      <UILanguage>en-US</UILanguage>
      <UserLocale>en-US</UserLocale>
    </component>
    <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State">
      <AutoLogon>
        <Password>
          <Value>${ADMIN_PASS}</Value>
          <PlainText>true</PlainText>
        </Password>
        <Enabled>true</Enabled>
        <Username>Administrator</Username>
      </AutoLogon>
      <UserAccounts>
        <AdministratorPassword>
          <Value>${ADMIN_PASS}</Value>
          <PlainText>true</PlainText>
        </AdministratorPassword>
      </UserAccounts>
      <OOBE>
        <HideEULAPage>true</HideEULAPage>
        <NetworkLocation>Work</NetworkLocation>
        <ProtectYourPC>3</ProtectYourPC>
        <HideWirelessSetupInOOBE>true</HideWirelessSetupInOOBE>
      </OOBE>
      <RegisteredOwner>Sunil Kumar</RegisteredOwner>
      <RegisteredOrganization>AutoInstall</RegisteredOrganization>
      <FirstLogonCommands>
        <SynchronousCommand wcm:action="add">
          <Order>1</Order>
          <CommandLine>cmd /c net user Administrator ${ADMIN_PASS}</CommandLine>
          <Description>Set Administrator Password</Description>
        </SynchronousCommand>
        <SynchronousCommand wcm:action="add">
          <Order>2</Order>
          <CommandLine>cmd /c reg add "HKLM\System\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f</CommandLine>
          <Description>Enable RDP</Description>
        </SynchronousCommand>
        <SynchronousCommand wcm:action="add">
          <Order>3</Order>
          <CommandLine>cmd /c netsh advfirewall firewall set rule group="remote desktop" new enable=Yes</CommandLine>
          <Description>Allow RDP in Firewall</Description>
        </SynchronousCommand>
      </FirstLogonCommands>
    </component>
  </settings>

  <cpi:offlineImage cpi:source="wim:/sources/install.wim#Windows Server 2025 SERVERSTANDARD" xmlns:cpi="urn:schemas-microsoft-com:cpi" />
</unattend>
EOF

# Create secondary ISO with autounattend.xml
mkisofs -o "$OUT" -V "AUTOUNATTEND" -J -R "$WORK"

echo "[+] Done!"
echo "Attach both ISOs to your Proxmox VM:"
echo "  1. Windows ISO (primary boot)"
echo "  2. $OUT (as secondary CD-ROM)"
echo "VirtIO drivers included; install auto-detects them."
