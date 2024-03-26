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
    print "0"
}

# Process vertex data
/^element vertex/ {
    vertices = $3
}

/^end_header/{
    getline
    for (i = 1; i <= vertices; i++) {
        for (j = 1; j < vertices; j++) {
            vertexList[i,j] = $j
            # print vertexList[i,j];
    }
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
}}
{
    }

# Process face data
# /^element face/ {
#     faces = $3
#     for (i = 1; i <= faces; i++) {
#         getline
#         split($0, indices)
#         print "0"
#         print "LINE"
#         print "8"
#         print "0"  # Layer name, adjust as needed
#         print "10"
#         print indices[2]  # X coordinate of vertex 1
#         print "20"
#         print indices[3]  # Y coordinate of vertex 1
#         print "30"
#         print "0.0"  # Z coordinate of vertex 1
#         print "11"
#         print indices[3]  # X coordinate of vertex 2
#         print "21"
#         print indices[4]  # Y coordinate of vertex 2
#         print "31"
#         print "0.0"  # Z coordinate of vertex 2
#         print "0"  # End of LINE entity
#     }
# }

# # END block: Close DXF sections
# END {
#     print "0"
#     print "ENDSEC"
#     print "0"
#     print "EOF"
# }