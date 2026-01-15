#import "../config/variables.typ" : myName, myTitle, myTitle2, myDegree, myAA, myUni


#align(left + bottom, [
    #text(myName),
        #text(style: "italic", myTitle) #text(style: "italic", myTitle2) \
    #text(myDegree) ,  #text(myUni),  #sym.copyright #text(myAA)
])
