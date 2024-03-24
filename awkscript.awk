# BEGIN block: Initialize DXF header and section
BEGIN {
    print "0"
    print "SECTION"
    print "2"
    print "HEADER"
    print "0"
    print "ENDSEC"
    print "0"
    print "SECTION"
    print "2"
    print "ENTITIES"
}

# Process vertex data
/^element vertex/ {
    vertices = $3
    print "0"
    print "POLYLINE"
    print "8"
    print "0"  # Layer name, adjust as needed
    print "66"
    print "1"  # Polyline is closed
    for (i = 1; i <= vertices; i++) {
        getline
        split($0, coords)
        print "0"
        print "VERTEX"
        print "8"
        print "0"  # Layer name, adjust as needed
        print "10"
        print coords[1]  # X coordinate
        print "20"
        print coords[2]  # Y coordinate
        print "30"
        print coords[3]  # Z coordinate
    }
}

# Process face data
/^element face/ {
    faces = $3
    for (i = 1; i <= faces; i++) {
        getline
        split($0, indices)
        print "0"
        print "LINE"
        print "8"
        print "0"  # Layer name, adjust as needed
        print "10"
        print indices[2]  # X coordinate of vertex 1
        print "20"
        print indices[3]  # Y coordinate of vertex 1
        print "30"
        print "0.0"  # Z coordinate of vertex 1
        print "11"
        print indices[3]  # X coordinate of vertex 2
        print "21"
        print indices[4]  # Y coordinate of vertex 2
        print "31"
        print "0.0"  # Z coordinate of vertex 2
        print "0"  # End of LINE entity
    }
}

# END block: Close DXF sections
END {
    print "0"
    print "ENDSEC"
    print "0"
    print "EOF"
}