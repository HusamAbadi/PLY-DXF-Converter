# powershell -File "PowershellScript.ps1"

param (
    [Parameter(Mandatory = $true)]
    [string]$InputFilePath, # Path to the input file

    [Parameter(Mandatory = $true)]
    [string]$OutputFilePath     # Path to the output file
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
    # Override the Equals method to compare vertices
    [bool] Equals([object]$other) {
        if ($other -isnot [Vertex]) {
            return $false
        }
        return ($this.x -eq $other.x -and $this.y -eq $other.y -and $this.z -eq $other.z)
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

    Face([Vertex[]]$vlist) {
        $this.vlist = $vlist
        $this.vnum = $vlist.Count
    }
    [void] AddVertex([Vertex]$newVertex) {
        $this.vlist += $newVertex
    }
    Face() {
        $this.vlist = @()
        $this.vnum = 0
    }
    [int] IndexOfVertex([Vertex]$vertex) {
        return [Array]::IndexOf($this.vlist, $vertex)
    }
}
$verticesList = @()
$vertex = @()
$line = @()
$lines = @()
$i = 0
$j = 1
$debuga = @()
$debug = 0
$face_count = 0
$face = ""
$object = ""
$vertex_count = 0
$record_num = 1
$records = Get-Content -Path $InputFilePath   # Read the lines from the input file

foreach ($record in $records) {
        
    if ($record -match "^(VERTEX)$") {
        $vertex_count++
        $vertex = [Vertex]::new($records[$record_num + 3], $records[$record_num + 5], $records[$record_num + 7])

        $verticesList += $vertex
        $object += "$($vertex.x) $($vertex.y) $($vertex.z)`n"
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
        $face_count++
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
                $face.vlist += ($vertex)
                $i += 5
                # $object += $verticesList.IndexOf($face.vlist[$j])
                $j++
                # $object += [string[]]$verticesList.IndexOf([string[]]$vertex)
                # $object += $verticesList.IndexOf([Vertex]("0.0, 0.0, 0.0"))
            }
            $i++
        }
        $face.vnum = $j
        $object += "$($face.vnum) "
        foreach ($faceVertex in $face.vlist) {
            $index = $verticeslist.IndexOf($faceVertex)
            if ($index -ne -1) {
                $object += "$($index) "
            }
        }
        $object += "`n"
        $face.vnum = $j
        # $debuga += "$($face.vlist[0].x) $($face.vlist[1]) $($face.vlist[2])`n"
        # $debuga += $face.vlist[0] ,$face.vlist[1], $face.vlist[2], $face.vlist[3]
    }
    $record_num++
}

$header = @"
ply
format ascii 1.0
element vertex $vertex_count
property float x
property float y
property float z
element face $face_count
property list uchar int vertex_indices
end_header

"@

$header + $object | Out-File -FilePath $OutputFilePath
# $debuga