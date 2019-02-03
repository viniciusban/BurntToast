Import-Module "$PSScriptRoot/../BurntToast/BurntToast.psd1" -Force

Describe 'New-BTAction' {
    Context 'running without arguments' {
        It 'returns a [ToastActionsCustom] object' {
            New-BTAction | Should -BeOfType 'Microsoft.Toolkit.Uwp.Notifications.ToastActionsCustom'
        }

        Start-Transcript tmp.log
        try {
            New-BTAction -WhatIf
        }
        finally {
            Stop-Transcript
            $Log = (Get-Content tmp.log).Where({ $_ -match "What if: " })
            Remove-Item tmp.log
        }
        It 'has consitent WhatIf response' {
            $Expected = 'What if: Performing the operation "New-BTAction" on target "returning: [ToastActionsCustom] with 0 Inputs, 0 Buttons, and 0 ContextMenuItems".'
            $Log -join [System.Environment]::NewLine | Should -Be $Expected
        }
    }
    Context 'snooze and dismiss modal' {
        It 'returns a [ToastActionsSnoozeAndDismiss] object' {
            New-BTAction -SnoozeAndDismiss | Should -BeOfType 'Microsoft.Toolkit.Uwp.Notifications.ToastActionsSnoozeAndDismiss'
        }

        Start-Transcript tmp.log
        try {
            New-BTAction -SnoozeAndDismiss -WhatIf
        }
        finally {
            Stop-Transcript
            $Log = (Get-Content tmp.log).Where({ $_ -match "What if: " })
            Remove-Item tmp.log
        }
        It 'has consitent WhatIf response' {
            $Expected = 'What if: Performing the operation "New-BTAction" on target "returning: [ToastActionsSnoozeAndDismiss] with 0 Inputs, 0 Buttons, and 0 ContextMenuItems".'
            $Log -join [System.Environment]::NewLine | Should -Be $Expected
        }
    }
    Context 'single clickable button' {
        It 'returns a [ToastActionsCustom] object' {
            New-BTAction -Buttons (New-BTButton -Content 'Google' -Arguments 'https://google.com') | Should -BeOfType 'Microsoft.Toolkit.Uwp.Notifications.ToastActionsCustom'
        }

        Start-Transcript tmp.log
        try {
            New-BTAction -Buttons (New-BTButton -Content 'Google' -Arguments 'https://google.com') -WhatIf
        }
        finally {
            Stop-Transcript
            $Log = (Get-Content tmp.log).Where({ $_ -match "What if: " })
            Remove-Item tmp.log
        }
        It 'has consitent WhatIf response' {
            $Expected = 'What if: Performing the operation "New-BTAction" on target "returning: [ToastActionsCustom] with 0 Inputs, 1 Buttons, and 0 ContextMenuItems".'
            $Log -join [System.Environment]::NewLine | Should -Be $Expected
        }
    }
    Context 'mixed content: button & context menu' {
        $Button = New-BTButton -Content 'Google' -Arguments 'https://google.com'
        $ContextMenuItem = New-BTContextMenuItem -Content 'Bing' -Arguments 'https://bing.com'

        It 'returns a [ToastActionsCustom] object' {
            New-BTAction -Buttons $Button -ContextMenuItems $ContextMenuItem | Should -BeOfType 'Microsoft.Toolkit.Uwp.Notifications.ToastActionsCustom'
        }

        Start-Transcript tmp.log
        try {
            New-BTAction -Buttons $Button -ContextMenuItems $ContextMenuItem -WhatIf
        }
        finally {
            Stop-Transcript
            $Log = (Get-Content tmp.log).Where({ $_ -match "What if: " })
            Remove-Item tmp.log
        }
        It 'has consitent WhatIf response' {
            $Expected = 'What if: Performing the operation "New-BTAction" on target "returning: [ToastActionsCustom] with 0 Inputs, 1 Buttons, and 1 ContextMenuItems".'
            $Log -join [System.Environment]::NewLine | Should -Be $Expected
        }
    }
}

Describe 'New-BTAppId' {
    Mock 'New-Item' {}
    Mock 'New-ItemProperty' {}
    Mock 'Test-Path' {return $false}

    Context 'running without arguments' {
        It 'checks the mock' {
            Test-Path 'C:\Demos\01_chatter.ps1' | Should -Be $false
        }
        It 'attempts to add item to the registry' {
            New-BTAppId

            Assert-MockCalled 'New-Item' -Exactly 1 -Scope It
            Assert-MockCalled 'New-ItemProperty' -Exactly 1 -Scope It
        }

        Start-Transcript tmp.log
        try {
            New-BTAppId -WhatIf
        }
        finally {
            Stop-Transcript
            $Log = (Get-Content tmp.log).Where({ $_ -match "What if: " })
            Remove-Item tmp.log
        }
        It 'has consitent WhatIf response' {
            $Expected = 'What if: Performing the operation "New-BTAppId" on target "creating: ''HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe'' with property ''ShowInActionCenter'' set to ''1'' (DWORD)".'
            $Log -join [System.Environment]::NewLine | Should -Be $Expected
        }
    }
    Context 'running with custom AppId' {
        It 'attempts to add item to the registry' {
            New-BTAppId -AppId 'Script Checker'

            Assert-MockCalled 'New-Item' -Exactly 1 -Scope It
            Assert-MockCalled 'New-ItemProperty' -Exactly 1 -Scope It
        }

        Start-Transcript tmp.log
        try {
            New-BTAppId -AppId 'Script Checker'
        }
        finally {
            Stop-Transcript
            $Log = (Get-Content tmp.log).Where({ $_ -match "What if: " })
            Remove-Item tmp.log
        }
        It 'has consitent WhatIf response' {
            $Expected = 'What if: Performing the operation "New-BTAppId" on target "creating: ''HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Script Checker'' with property ''ShowInActionCenter'' set to ''1'' (DWORD)".'
            $Log -join [System.Environment]::NewLine | Should -Be $Expected
        }
    }
}





Describe 'New-BurntToastNotification' {
    Context 'running without arguments' {
        It 'runs without errors' {
            { New-BurntToastNotification } | Should -Not Throw
        }

        It 'does not return anything' {
            New-BurntToastNotification | Should -BeNullOrEmpty
        }
    }
    Context 'running with arguments (Image)' {
        It 'runs without errors' {
            { New-BurntToastNotification -AppLogo 'https://raw.githubusercontent.com/Windos/BurntToast/master/Media/BurntToast-Logo.png' } | Should -Not Throw
        }

        It 'does not return anything' {
            New-BurntToastNotification -AppLogo 'https://raw.githubusercontent.com/Windos/BurntToast/master/Media/BurntToast-Logo.png' | Should -BeNullOrEmpty
        }
    }
}
