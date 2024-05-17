#To execute a PowerShell script from cmd:

# powershell -File "PowershellScript.ps1"

param (
    [Parameter(Mandatory = $true)]
    [string]$InputFilePath # Path to the input file

    #     [Parameter(Mandatory = $true)]
    #     [string]$OutputFilePath     # Path to the output file
)
class Vertex {
    [string]$x
    [string]$y
    [string]$z

    Vertex([string]$x, [string]$y, [string]$z) {
        $this.x = $x
        $this.y = $y
        $this.z = $z
    }
    Vertex() {
    }
}
class Line {
    [Vertex]$v1
    [Vertex]$v2

    Line([Vertex]$v1, [Vertex]$v2) {
        $this.v1 = $v1
        $this.v1 = $v2
    }
    Line() {
    }
}

# class Face {
#     [Line]$l1
#     [Line]$l2
#     [Line]$l3
#     [Line]$l4
#     Face([Line]$l1, [Line]$l2, [Line]$l3, [Line]$l4) {
#         $this.l1 = $l1
#         $this.l2 = $l2
#         $this.l3 = $l3
#         $this.l4 = $l4
#     }
#     Face() {
#     }
# }
class Face {
    [Vertex[]]$vlist = @($v1, $v2, $v3)
    [int]$vnum = $vlist.Count

    Face([Line[]]$lineslist, [int]$linesnum) {
        $this.lineslist = $lineslist
        $this.linesnum = $lineslist.Count
    }
    [void] AddLine([Line]$newLine) {
        $this.lineslist += $newLine
    }
    # [void] AddLine([Line]$newLine) {
    #     $this | Add-Member -NotePropertyName "newLine" -NotePropertyValue $newLine
    # }

}
$verticesList = @()
$vertex = @()
$svertex = ""
$vertex2show = ""
$line2show = ""
$line = @()
$lines = @()
$points = @()
$spoint = ""
$i = 0
$debuga = @()
$debug = 0
$faces = 0
$face = ""
$object = ""
$indices = ""
$vertex_count = 0
$record_num = 0
$verticesArray = @()
$records = Get-Content -Path $InputFilePath   # Read the lines from the input file

foreach ($record in $records) {
    $x = $y = $z = $x1 = $y1 = $z1 = $x2 = $y2 = $z2 = $x3 = $y3 = $z3 = $x4 = $y4 = $z4 = $point1 = $point2 = "NULL"
    $record_num++

    if ($record -match "^(VERTEX|LINE|FACE|3DFACE)$") {
        # Check if the line represents a vertex or face
        $skipping = $true
        $face_vertices = 0
        $aFACE = $false

        if ($record -match "^(VERTEX)$") {

            $vertex = [Vertex]::new($records[$record_num + 3], $records[$record_num + 5], $records[$record_num + 7])

            $object += "$($vertex.x) $($vertex.y) $($vertex.z)`n"
            $verticesList += , $vertex
            
            # $debuga += $vertex
        }

        if ($record -match "^(LINE)$") {
            
            $line = [Line]::new()

            foreach ($vertex in $verticesList) {
                if ($vertex.x -eq $records[$record_num + 3] -and $vertex.y -eq $records[$record_num + 5] -and $vertex.z -eq $records[$record_num + 7]) {
                    $line.v1 = $vertex
                    # $debuga += $line.v1.x
                }
                if ($vertex.x -eq $records[$record_num + 9] -and $vertex.y -eq $records[$record_num + 11] -and $vertex.z -eq $records[$record_num + 13]) {
                    $line.v2 = $vertex
                    # $debuga += $line.v2.x
                }
            }
            $lines += , $line
            # $debuga = $lines
            # $debug = $lines[1].v1.x + $lines[1].v1.y + $lines[1].v1.z + $lines[1].v2.x + $lines[1].v2.y + $lines[1].v2.z

            $object += "$($verticesList.IndexOf($line.v1)) $($verticesList.IndexOf($line.v2))`n"

        }

        if ($record -match "^(FACE)$") {

            $face = [Face]::new()
        
        }

        elseif (-not $skipping) {
            # If not skipping, process the object data
            $object += "$x1 $y1 $z1`n"
            $vertex_count++
            if ($x2 -match '^\d+(\.\d+)?$') {
                $object += "$x2 $y2 $z2`n"
                $vertex_count++
            }
            if ($x3 -match '^\d+(\.\d+)?$') {
                $object += "$x3 $y3 $z3`n"
                $vertex_count++
            }
            if ($x4 -match '^\d+(\.\d+)?$') {
                $object += "$x4 $y4 $z4`n"
                $vertex_count++
            }
        }
    }
}

$header = @"
ply
format ascii 1.0
element vertex $vertex_count
property float x
property float y
property float z
element face $faces
property list uchar int vertex_indices
end_header

"@

$header + $object 
# + $indices| Out-File -FilePath $OutputFilePath    

# + $face