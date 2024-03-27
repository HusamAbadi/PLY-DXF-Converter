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
{
    if($1 ~ /^(end_header)$/){
        getline
        for (i = 1; i <= vertices; i++) {
            for (j = 1; j < vertices; j++) {
                vertexList[i,j] = $j
                # print vertexList[i,j]
            }
                getline 
        }
        for(a = 1; a <= faces; a++){
            faceVerticesNum[a] = $1
            for(b = 1; b <= faceVerticesNum[a]; b++){
                faceVertices[a][b] = $(b+1)
                # print faceVertices[a][b]
            }       
        getline
        }
    }
}

END{
    
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

        print "0"
        print "8"
        print "0"  # Layer name

        for(j = 1; j <= faceVerticesNum[i]; j++){
            # print faceVerticesNum[i]
            l = 1
            while(l <= 3){
                print (10 * l) + j - 1
                print vertexList[faceVertices[i][j]+1,l]
                l++;
            }
        }
            print "0"  # End of LINE entity
    }
}
# END block: Close DXF sections
END {
    print "ENDSEC"
    print "0"
    print "EOF"
}