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

# Storing Number of Vertices
/^element vertex/ {
    verticesNum = $3
}
# Storing Number of Faces
/^element face/ {
    facesNum = $3
}

#Storing Vertices and Faces Data In Arrays of Arrays
{
    if($1 ~ /^(end_header)$/){
        getline
        for (i = 1; i <= verticesNum; i++) {
            for (j = 1; j < 4; j++) {
                verticesList[i,j] = $j
                # print verticesList[i,j]
            }
            getline 
        }
        for(a = 1; a <= facesNum; a++){
            faceVerticesNum[a] = $1
            for(b = 1; b <= faceVerticesNum[a]; b++){
                facesList[a][b] = $(b+1)
                # print facesList[a][b]
            }       
        getline
        }
    }
}

END{
    
    #Printing Vertices Data in DXF Format
    for(i = 1; i <= verticesNum; i++){
        print "VERTEX" #Start Entity
        print "8"
        print "0" #Layer Name
        print "10" #X-axis
        print verticesList[i,1]
        print "20" #Y-axis
        print verticesList[i,2]
        print "30" #Z-axis
        print verticesList[i,3]
        print "0" #End Entity
    }

    #Printing Faces Data in DXF Format
    for (i = 1; i <= facesNum; i++) {
        print "FACE"

        print "0"
        print "8"
        print "0"  # Layer name

        for(j = 1; j <= faceVerticesNum[i]; j++){
            # print faceVerticesNum[i]
            l = 1
            while(l <= 3){
                print (10 * l) + j - 1
                print verticesList[facesList[i][j]+1,l]
                l++;
            }
            # The Boundary of the While Loop is 3 because it's the maximum multiple of 10 we need
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