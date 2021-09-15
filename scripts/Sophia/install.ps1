Clear-Host
$Host.UI.RawUI.WindowTitle = 'Windows Sophia Script | Copyright farag2 & Inestic, 2015 to 2021'
Remove-Module -Name Sophia -Force -ErrorAction Ignore
Import-Module -Name $PSScriptRoot\Manifest\Sophia.psd1 -PassThru -Force
Import-LocalizedData -BindingVariable Global:Localization -FileName Sophia -BaseDirectory $PSScriptRoot\Localizations

#region Protection


#endregion Protection

#region Privacy & Telemetry

DiagTrackService -Disable
DiagnosticDataLevel -Minimal
ErrorReporting -Disable
FeedbackFrequency -Never
SigninInfo -Disable
LanguageListAccess -Disable
AdvertisingID -Disable
WindowsWelcomeExperience -Hide
WindowsTips -Disable
SettingsSuggestedContent -Hide
AppsSilentInstalling -Disable
WhatsNewInWindows -Disable
TailoredExperiences -Disable

#endregion Privacy & Telemetry

#region UI & Personalization

ThisPC -Show
FileExtensions -Show
MergeConflicts -Show
OpenFileExplorerTo -ThisPC
CortanaButton -Hide
OneDriveFileExplorerAd -Hide
RecycleBinDeleteConfirmation -Enable
3DObjects -Hide
TaskViewButton -Hide
PeopleTaskbar -Hide
TaskbarSearch -SearchIcon
WindowsInkWorkspace -Hide
MeetNow -Hide
NewsInterests -Disable
WindowsColorMode -Dark
AppColorMode -Dark
NewAppInstalledNotification -Hide
JPEGWallpapersQuality -Max
ShortcutsSuffix -Disable
UnpinTaskbarShortcuts -Shortcuts Store, Mail

#endregion UI & Personalization

#region OneDrive

OneDrive -Uninstall

#endregion OneDrive

#region System

StorageSense -Enable
StorageSenseTempFiles -Enable
StorageSenseFrequency -Month
Win32LongPathLimit -Disable
BSoDStopError -Enable
AdminApprovalMode -Never
WindowsSandbox -Enable
DeliveryOptimization -Disable
WindowsFeatures -Disable
WindowsCapabilities -Uninstall
UpdateMicrosoftProducts -Enable
PowerPlan -High
ReservedStorage -Disable
F1HelpPage -Disable
NumLock -Enable
StickyShift -Disable
NetworkDiscovery -Enable
ActiveHours -Automatically

#endregion System

#region WSL
#WSL
#endregion WSL

#region Start menu

RecentlyAddedApps -Hide
AppSuggestions -Hide
RunPowerShellShortcut -NonElevated
PinToStart -UnpinAll
PinToStart -Tiles ControlPanel, PowerShell

#endregion Start menu

#region UWP apps

UninstallUWPApps -ForAllUsers

#endregion UWP apps

#region Gaming

XboxGameBar -Disable
XboxGameTips -Disable

#endregion Gaming

#region Scheduled tasks

CleanupTask -Register
SoftwareDistributionTask -Register
TempTask -Register

#endregion Scheduled tasks

#region Context menu

MSIExtractContext -Hide
CABInstallContext -Show
CastToDeviceContext -Hide
ShareContext -Hide
EditWithPaint3DContext -Hide
CreateANewVideoContext -Hide
ImagesEditContext -Hide
PrintCMDContext -Hide
IncludeInLibraryContext -Hide
BitLockerContext -Hide
BitmapImageNewContext -Hide
RichTextDocumentNewContext -Hide
CompressedFolderNewContext -Hide
MultipleInvokeContext -Enable
UseStoreOpenWith -Hide

#endregion Context menu

RefreshEnvironment
Errors