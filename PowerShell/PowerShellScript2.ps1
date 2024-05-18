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

class Face {
    [Vertex]$v1
    [Vertex]$v2
    [Vertex]$v3

    [Vertex[]]$vlist = @($v1, $v2, $v3)
    [int]$vnum = $vlist.Count

    Face([Vertex[]]$vlist, [int]$vnum) {
        $this.vlist = $vlist
        $this.vnum = $vlist.Count
    }
    [void] AddVertex([Vertex]$newVertex) {
        $this.vlist += $newVertex
    }
    Face() {
        
    }
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
$j = 1
$k = 0
$l = 1
$debuga = @()
$debug = 0
$faces = 0
$face = ""
$object = ""
$indices = ""
$vertex_count = 0
$record_num = 1
$verticesArray = @()
$records = Get-Content -Path $InputFilePath   # Read the lines from the input file

foreach ($record in $records) {
    # $x = $y = $z = $x1 = $y1 = $z1 = $x2 = $y2 = $z2 = $x3 = $y3 = $z3 = $x4 = $y4 = $z4 = $point1 = $point2 = "NULL"

    if ($record -match "^(VERTEX|LINE|FACE|3DFACE)$") {
        # Check if the line represents a vertex or face
        $skipping = $true
        $face_vertices = 0
        $aFACE = $false

        if ($record -match "^(VERTEX)$") {

            $vertex = [Vertex]::new($records[$record_num + 3], $records[$record_num + 5], $records[$record_num + 7])

            $object += "$($vertex.x) $($vertex.y) $($vertex.z)`n"
            $verticesList += $vertex
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
            # $debug = $lines[1].v1.x + $lines[1].v1.y + $lines[1].v1.z + $lines[1].v2.x + $lines[1].v2.y + $lines[1].v2.z

            $object += "$($verticesList.IndexOf($line.v1)) $($verticesList.IndexOf($line.v2))`n"
            # $debuga += "$($verticesList.IndexOf($line.v1)) $($verticesList.IndexOf($line.v2))"
        }

        if ($record -match "^(FACE)$") {
            $face = [Face]::new()
            $i = 3
            $j = 0
            while ($records[$record_num + $i ] -ne 0) {
                # $debuga += "" + ($record_num + $i + 1) + "`n" + $records[$record_num + $i]
                if ($j -ge 3) {
                    $face.AddVertex([Vertex]::new($records[$record_num + $i + 1], $records[$record_num + $i + 3], $records[$record_num + $i + 5]))
                    $i += 5
                    $j++
                }
                else {
                    $vertex = [Vertex]::new($records[$record_num + 1 + $i], $records[$record_num + 1 + $i + 2], $records[$record_num + 1 + $i + 4])
                    $face.vlist[$j] = $vertex
                    $i += 5
                    $j++
                }
                $i++
            }
            $face.vnum = $j
            $new = $($verticesList.IndexOf($face.vlist[1]))
            # $object += "$($face.vnum) $($verticesList.IndexOf($face.vlist.0)) $($verticesList.IndexOf($face.vlist[1])) $($verticesList.IndexOf($face.vlist[2]))`n"
            
            # $debuga += "$($face.vlist[0].x) $($face.vlist[1]) $($face.vlist[2])`n"
            # $debuga += $face.vlist[0] ,$face.vlist[1], $face.vlist[2], $face.vlist[3]
            # $debuga += $verticesList.IndexOf([Vertex]::new(0.0, 0.0, 0.0))
            # $debuga = $verticesList[0]
            $debug = $new
        }
    }

    # elseif (-not $skipping) {
    #     # If not skipping, process the object data
    #     $object += "$x1 $y1 $z1`n"
    #     $vertex_count++
    #     if ($x2 -match '^\d+(\.\d+)?$') {
    #         $object += "$x2 $y2 $z2`n"
    #         $vertex_count++
    #     }
    #     if ($x3 -match '^\d+(\.\d+)?$') {
    #         $object += "$x3 $y3 $z3`n"
    #         $vertex_count++
    #     }
    #     if ($x4 -match '^\d+(\.\d+)?$') {
    #         $object += "$x4 $y4 $z4`n"
    #         $vertex_count++
    #     }
    # }
    $record_num++
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

$object 
$debuga
$debug
# + $indices| Out-File -FilePath $OutputFilePath    

# + $face