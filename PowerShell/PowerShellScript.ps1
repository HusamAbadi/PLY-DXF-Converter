#To execute a PowerShell script from cmd:

# powershell -File "PowershellScript.ps1"

param (
    [Parameter(Mandatory = $true)]
    [string]$InputFilePath # Path to the input file

    #     [Parameter(Mandatory = $true)]
    #     [string]$OutputFilePath     # Path to the output file
)
$verticesList = @()
$vertex = @()
$svertex = ""
$vertex2show = ""
$line2show = ""
$line = @()
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
            $vertex = New-Object PSObject -Property @{
                # $x = $records[$record_num + 2]
                # $y = $records[$record_num + 4]
                # $z = $records[$record_num + 6]
            }
            $x = $records[$record_num + 3]
            $y = $records[$record_num + 5]
            $z = $records[$record_num + 7]

            $vertex2show += "$x $y $z`n"
            
            $vertex = @($x, $y, $z)
            $verticesList += , $vertex
            $debuga = $verticesList
        }

        if ($record -match "^(LINE)$") {
            $x = $records[$record_num + 3]
            $y = $records[$record_num + 5]
            $z = $records[$record_num + 7]
            $point1 = @($x, $y, $z)
            $points += , $point1
            
            $x2 = $records[$record_num + 9]
            $y2 = $records[$record_num + 11]
            $z2 = $records[$record_num + 13]
            $point2 = @($x2, $y2, $z2)
            $points += , $point2
            
            # $debuga = $points[0] + $points[1] + $points[2] + $points[3]
            foreach ($point in $points) {
                $spoint = $point -join ", "
                foreach ($vertex in $verticesList) {
                    $svertex = $vertex -join ", "
                    if ($spoint -eq $svertex) {
                        $debug++
                        # $line2show += $verticesList.IndexOf($vertex)
                        $line += $verticesList.IndexOf($vertex)
                        # $debug += $verticesList.IndexOf($vertex)
                        # $debuga += "`n$svertex`n$spoint`n"
                    }
                }
            }
            # for (let i = 0; i -lt array.length; i += 2) {
            #     console.log(`$ { array[i] } ${array[i + 1]})
            #     }
            # $lines += , @($point1 + $point2)
            # $lines += , $line 
            # $deblines += $LPoint1, $LPoint2
            
            # foreach ($point in $lines) {
            #     $debug += $point 
            #     # if ($point -eq $verticesList[0]) {
            #     #     $debug += $point 
            #     # }
            #     $i++
            # }
            
        }


        # if ($x -match "^ *10 *$") {
        #     # Check if the line contains x1, y1, z1 coordinates
        #     $skipping = $false
        #     $x1 = $records[$record_num + 3]
        #     $y1 = $records[$record_num + 5]
        #     $z1 = $records[$record_num + 7]
        # }
        
        # $x = $records[$records.IndexOf($record) + 9]
        # if ($x -match "^ *11 *$") {
        #     # Check if the line contains x2, y2, z2 coordinates
        #     $skipping = $false
        #     $x2 = $records[$record_num + 9]
        #     $y2 = $records[$record_num + 11]
        #     $z2 = $records[$record_num + 13]
        # }

        # $x = $records[$records.IndexOf($record) + 15]
        # if ($x -match "^ *12 *$") {
        #     # Check if the line contains x3, y3, z3 coordinates
        #     $face_vertices++
        #     $x3 = $records[$record_num + 15]
        #     $y3 = $records[$record_num + 17]
        #     $z3 = $records[$record_num + 19]
        # }

        # $x = $records[$records.IndexOf($record) + 21]
        # if ($x -match "^ *13 *$") {
        #     # Check if the line contains x4, y4, z4 coordinates
        #     $face_vertices++
        #     $x4 = $records[$record_num + 21]
        #     $y4 = $records[$record_num + 23]
        #     $z4 = $records[$record_num + 25]
        # }

        # if ($record -match "^(FACE| 3DFACE)$") {
        #     # If it's a 3DFACE, process the face data
        #     $faces++    # Increment the face count
        #     $face += "$x1 $y1 $z1`n$x2 $y2 $z2`n"
        #     if ($x3 -match '^\d+(\.\d+)?$') {
        #         # Check if we have a valid 3rd vertex 
        #         $face += "$x3 $y3 $z3`n"
        #         $face_vertices++
        #     }
        #     if ($x4 -match '^\d+(\.\d+)?$') {
        #         # Check if we have a valid 4th vertex
        #         $face += "$x4 $y4 $z4`n"
        #         $face_vertices++
        #     }
                
        #     $vertex_indices = $vertex_count
        #     $indices += "$face_vertices"
        #     for ($i = 0; $i -lt $face_vertices; $i++) {
        #         $indices += " $($vertex_indices + $i + 1)"   # Add vertex indices to the indices string
        #     }
        #     $indices += "`n"

        #     $vertex_count += $face_vertices   # Increment the vertex count
        # }
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

# $verticesList + "`n" + $line[0] + "`n" + $debug
$header + $vertex2show + $line2show + $debug + $debuga
# + $indices| Out-File -FilePath $OutputFilePath    

# + $face