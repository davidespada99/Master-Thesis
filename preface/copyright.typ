#import "../config/variables.typ" : myName, myTitle, myTitle2, myDegree, myAA, myUni

#set par(first-line-indent: 0em)
#align(left + bottom, [
    #text(myName),
        #text(style: "italic", myTitle) #text(style: "italic", myTitle2) \
    #text(myDegree) ,  #text(myUni),  #sym.copyright #text(myAA)
])
