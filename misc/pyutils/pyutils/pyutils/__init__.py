# create a dictionary with all the IUPAC nucleotide codes

codeIUPAC = {'A': 'A', 'T': 'T', 'G': 'G', 'C': 'C', 
            'R': ['A', 'G'], 'Y': ['C', 'T'], 
            'S': ['G', 'C'], 'W': ['A', 'T'], 
            'K': ['G', 'T'], 'M': ['A', 'C'], 
            'B': ['C', 'G', 'T'], 'D': ['A', 'G', 'T'], 
            'H': ['A', 'C', 'T'], 'V': ['A', 'C', 'G'], 
            'N': ['A', 'T', 'G', 'C']}


# function to get all possible sequences from degenerated primers

def getMixDegPrime(primer): 
    
    degList = list()
    for bp in range(len(primer)): 
        nt = primer[bp].upper()
    
        if (bp == 0): 
            if len(codeIUPAC[nt]) > 1: 
                for degNt in codeIUPAC[nt]:
                        degList.append(degNt) 
                    
            else: 
                degList.append(nt)

        if (bp != 0): 
            newDegList = list()
            for strNt in range(len(degList)):
                if len(codeIUPAC[nt]) > 1: 
                    for degNt in codeIUPAC[nt]:
                        newDegList.append(degList[strNt] + degNt)

                else: 
                    newDegList.append(degList[strNt] + nt)
    
            degList = newDegList # update list
    
    return(degList) 
    


##########################################################################################

# complementary nucleotides

compNt = {'A': 'T', 'T': 'A', 
         'G': 'C', 'C': 'G',
          'R': 'Y', 'Y': 'R',
          'S': 'S', 'W': 'W',
          'K': 'M', 'M': 'K',
          'B': 'V', 'V': 'B', 
          'D': 'H', 'H': 'D',
          'N': 'N'}
          
          
### Create a function to generate the reverse complement with IUPAC nucleotide codes

def revCompPrime(primer):

    primeLen = len(primer)
    revCompPrimer = ''
    for nt in range(1, primeLen + 1): 
        revCompPrimer = revCompPrimer + compNt[primer[-nt].upper()]
 
    return(revCompPrimer)
  
  
  
##########################################################################################

  
# define function to import any tab-delimited file into a dataframe

import pandas as pd 

def importTab2Df(tab_file, header = 'infer'):
	
	colNames = header
	
	tab_out = pd.read_csv(tab_file, sep = '\t', header = colNames)
	
	return(tab_out)
  
    
    
##########################################################################################

# count the number of different characters in a list and print a dictionary

def countChar(charList): 

    uniChar = sorted(set(charList))
    charListIn = sorted(charList)
    charListOut = list()
    #countCharOut = 
    
    for char in uniChar: 
        
        charListOut.append(charListIn.count(char)) 
    
    countCharOut = dict(zip(uniChar, charListOut))   

    return(countCharOut)

 
    
##########################################################################################

# find duplicates
    
def findDuplicates(dupList, unique=False):
    
    dupListOut = dupList[:]

    for ele in dupList: 
        if (dupList.count(ele)) < 2: 
            dupListOut.remove(ele)
    
    if unique == True: 
        dupListOut = list(set(dupListOut))
        
    return(dupListOut)



##########################################################################################

# concatenate sublists

def concSubLists(inList, sepChr):
	
	listOut = list()
	
	for ele in inList:
		if isinstance(ele, list):
			listOut.append(sepChr.join(ele))
		else: 
			listOut.append(ele)
	
	return(listOut)




##########################################################################################

# concatenate numeric sublists

def concNumSubLists(inList, sepChr):
	
	listOut = list()
	
	for ele in inList:
		if isinstance(ele, list):
			eleList = [str(i) for i in ele]
			listOut.append(sepChr.join(eleList))
		else: 
			listOut.append(str(ele))
	
	return(listOut)
	
	

##########################################################################################

# define function to retrieve sublits from a list 

def fishSubLists(inList):
    
    outList = [ele for ele in inList if isinstance(ele, list)]
    
    return(outList)
    


##########################################################################################

# linearize lists

def linearList(inList):
    outList = [el for ele in inList for el in ele]
    return(outList)


##########################################################################################

# parse fasta files

def parseFasta(fastaTxtFileDir, fastaParsedFileDir = None):
	
	import re

	fastaTxtFile = open(fastaTxtFileDir, 'r')
	fastaTxtFileParsed = open(fastaTxtFileDir + "Parsed.fasta", 'w')
	if fastaParsedFileDir != None: 
		fastaTxtFileParsed = open(fastaParsedFileDir, 'w')
	counter = 0

	for line in fastaTxtFile:
		counter += 1
		if line.startswith(">"):
			if counter != 1:
				lineParsed = re.sub(r'( |\.|\(|\)|\[|\]|\=)',"_", line)
				fastaTxtFileParsed.write("\n" + lineParsed)
			else: 
				lineParsed = re.sub(r'( |\.)',"_", line)
				fastaTxtFileParsed.write(lineParsed)
		
		elif not line.strip() == '':
			lineParsed = line.replace("\n", "")
			fastaTxtFileParsed.write(lineParsed)
	
	fastaTxtFileParsed.write("\n")
	fastaTxtFile.close()	
	fastaTxtFileParsed.close()	
	
	
##########################################################################################

# parse multi fasta files

def parseMultiFasta(multiFastaFilesDir): 
	
	
	for file in multiFastaFilesDir: 
		if not file.startswith("."):
			parseFasta(file)



##########################################################################################

# get list position

def getListPos(listIN, trackChr): 
	
	'''
	get [start,end] list position
	of a trackChr 
	'''
	
	listLen = len(listIN)
	posList = list()
	downChr = ''

	for i in range(listLen): 
		upChr = i 
		if len(posList) == 0 and listIN[i] == trackChr: 
			posList.append(i)   
		elif downChr != listIN[upChr] and downChr == trackChr:
			posList.append(i - 1)
            
		downChr = listIN[upChr]
		
	if listIN[-1] == trackChr:
		posList.append(i)
		
	return(posList)
	


##########################################################################################

# get list position

def pickIndex(listIN, targetChr): 
    
    '''
    Get the index of a character or integer!
    '''
    
    for i in range(len(listIN)):
        if str(listIN[i]) == str(targetChr): 
            return(i)


##########################################################################################

# get fasta by gene/genomic coordinates


def getFastabyCoord(fastaTxtFileDir, start_pos, end_pos, fastaParsedFileDir = None):

    import re

    fastaTxtFile = open(fastaTxtFileDir, 'r')
    if fastaParsedFileDir != None: 
        fastaTxtFileParsed = open(fastaParsedFileDir, 'w')
    else: 
        fastaTxtFileParsed = open(fastaTxtFileDir + "_from_" + str(start_pos) + "_to_" + str(end_pos) + ".fasta", 'w')
    listOut = []
    counter = 0

    for line in fastaTxtFile:
        counter += 1
        if line.startswith(">"):
            if counter != 1:
                lineParsed = re.sub(r'( |\.|\(|\)|\[|\]|\=)',"_", line)
                listOut.append(lineParsed)

            else: 
                lineParsed = re.sub(r'( |\.)',"_", line)
                listOut.append(lineParsed)
        elif not line.strip() == '':
            lineParsed = line.replace("\n", "")
            listOut.append(lineParsed)
        
    listOut_2 = [] 
    curr_fa = ""
    counter = 0 
    for l in listOut: 
        counter += 1
        if l.startswith(">"): 
            if len(listOut_2) == 0:
                listOut_2.append(l)
            else: 
                listOut_2.append(curr_fa)
                listOut_2.append(l)
        elif not (l.startswith(">")) and (len(listOut) != counter): 
            curr_fa = curr_fa + l
        elif not (l.startswith(">")) and (len(listOut) == counter): 
            curr_fa = curr_fa + l
            curr_fa_2 = curr_fa[(start_pos-1):end_pos]
            listOut_2.append(curr_fa_2)
    
    # write output
    [fastaTxtFileParsed.write(l) for l in listOut_2] 
    fastaTxtFile.close()
    fastaTxtFileParsed.close()	

##########################################################################################







    


