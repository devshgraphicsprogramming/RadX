#!/usr/bin/pwsh-preview

# It is helper for compilation shaders to SPIR-V

$INDIR="./"
$OUTDIR="../prebuilt/shaders/$VNDR/"
$HRDDIR="../prebuilt/intrusive/$VNDR/"
$RDXI="radix/"

$CMPPROF="-S comp"
$OPTFLAGS=" --inline-entry-points-exhaustive --workaround-1209 --replace-invalid-opcode --ccp --unify-const --simplify-instructions --remove-duplicates --combine-access-chains  --convert-local-access-chains --private-to-local --merge-return --merge-blocks --if-conversion --cfg-cleanup --flatten-decorations --freeze-spec-const "

function Pause ($Message = "Press any key to continue . . . ") {
#    if ((Test-Path variable:psISE) -and $psISE) {
#        $Shell = New-Object -ComObject "WScript.Shell"
#        $Button = $Shell.Popup("Click OK to continue.", 0, "Script Paused", 0)
#    }
#    else {     
#        Write-Host -NoNewline $Message
#        [void][System.Console]::ReadKey($true)
#        Write-Host
#    }
}

function Optimize($Name, $Dir = "", $AddArg = "") {
    $ARGS = "$OPTFLAGS $Dir$Name.spv -o $Dir$Name.spv $AddArg"
    $process = start-process -NoNewWindow -Filepath "spirv-opt" -ArgumentList "$ARGS" -PassThru
    $process.PriorityClass = 'BelowNormal'
    $process.WaitForExit()
    $process.Close()
}

function BuildCompute($Name, $InDir = "", $OutDir = "", $AddArg = "", $AltName = $Name) {
    $ARGS = "$CFLAGSV $CMPPROF $InDir$Name -o $OutDir$AltName.spv $AddArg"
    $process = start-process -NoNewWindow -Filepath "glslangValidator" -ArgumentList "$ARGS" -PassThru
    $process.PriorityClass = 'BelowNormal'
    $process.WaitForExit()
    $process.Close()
}


function BuildAllShaders($Pfx = "") {
    #[System.Threading.Thread]::CurrentThread.Priority = 'BelowNormal'
    [System.Threading.Thread]::CurrentThread.Priority = 'Highest'

    new-item -Name $HRDDIR$RDXI -itemtype directory  -Force | Out-Null

    # radix sort
    BuildCompute "permute.comp"    "$INDIR$RDXI" "$HRDDIR$RDXI"
    BuildCompute "histogram.comp"  "$INDIR$RDXI" "$HRDDIR$RDXI"
    BuildCompute "pfx-work.comp"   "$INDIR$RDXI" "$HRDDIR$RDXI"
    BuildCompute "copyhack.comp"   "$INDIR$RDXI" "$HRDDIR$RDXI"

    # optimize built shaders
    #OptimizeMainline
}

function OptimizeMainline($Pfx = "") {
    # optimize radix sort
    Optimize "permute.comp"   "$HRDDIR$RDXI"
    Optimize "histogram.comp" "$HRDDIR$RDXI"
    Optimize "pfx-work.comp"  "$HRDDIR$RDXI"
    Optimize "copyhack.comp"  "$HRDDIR$RDXI"
}


