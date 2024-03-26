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
    print "TABLES"
    print "0"
    print "ENDSEC"
    print "0"
    print "SECTION"
    print "2"
    print "BLOCKS"
    print "0"
    print "ENDSEC"
    print "0"
    print "SECTION"
    print "2"
    print "ENTITIES"
    print "0"
}

# Process vertex data
/^element vertex/ {
    vertices = $3
}
# Process face data
/^element face/ {
    faces = $3
}

NR == x{
    faceVerticesNum = $1
    for(a = 1; a <= faces; a++){
        for(b = 1; b <= faceVerticesNum; b++){
            faceVertices[a,b] = $(b+1)
        }
    }
}
/^end_header/{
    i = 1
    getline
    x = NR + vertices
    for (i = 1; i <= vertices; i++) {
        for (j = 1; j < vertices; j++) {
            vertexList[i,j] = $j
        }

        # for(k = 1; k <= faces; k++){
        #     faceVertices[k] = vertexList[i];

        # }
            getline
    }
    for(i = 1; i <= vertices; i++){
        print "VERTEX"
        print "8"
        print "0"
        print "10"
        print vertexList[i,1]
        print "20"
        print vertexList[i,2]
        print "30"
        print vertexList[i,3]
        print "0"
    }
    for (i = 1; i <= faces; i++) {
        print "FACE"
        # getline
        # split($0, indices)

        print "0"
        print "8"
        print "0"  # Layer name, adjust as needed
        for(j = 1; j < 4; j++){
            # print vertexList[i,j];

            print j + "9"
            print vertexList[faceVertices[i,1],j]  # X coordinate of vertex 1
            print j + "19"
            print vertexList[faceVertices[i,0],j]  # Y coordinate of vertex 1
            print j + "29"
            print vertexList[faceVertices[i,0],j]  # Z coordinate of vertex 1
            print "0"  # End of LINE entity
        }
    }
}

# END block: Close DXF sections
END {
    print "ENDSEC"
    print "0"
    print "EOF"
}