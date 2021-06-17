#--------------------------------------------------------------------------------------------------------------
# Description: Convert UniProt IDs to gene names (convert UniProt mappings)
# Author: António Sousa
# Date: 31/01/2021
# Latest update: 31/01/2021
#--------------------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------------------
# import modules
import urllib.parse
import urllib.request
from io import StringIO
import pandas as pd
#--------------------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------------------
# helper function to run below: 
# convert list input to str output
def list2str(in_list, sep = " "):
  
  '''
  'list2str()': converts a list into a str.
  
  ---
  
  params: 
  
  'in_list' (mandatory): a list (str).
  
  'sep' (mandatory): a delimiter/separator character (str). 
  By default space - 'sep = " "'.
  '''
  
  out_str = ''
  for ele in in_list: 
    out_str += ele + sep 
  out_str = out_str.strip(sep) # rm last sep character
  return(out_str)
#--------------------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------------------
# write function
def get_uniprot_id(list2convert, convert_from = "ACC+ID", convert_to = "GENENAME"):
  
  '''
  'get_uniprot_id()': converts a list of UniProt mapping ids. 
  
  ---
  
  params: 
  
  'list2convert' (mandatory): list of ids (str) to convert. It
  provides/returns a table (tab format) with the ids mapped 
  from ('convert_from') to ('convert_to').
  
  'convert_from' (mandatory): convert from (str) - type of id 
  provided in 'list2convert'. By default 'convert_from = "ACC+ID"'. 
  
  'convert_to' (mandatory): convert to (str) - type of the id to 
  convert to. By default 'convert_to = "GENENAME"'. 
  Please have a look into the attributes available: 
  https://www.uniprot.org/help/api_idmapping
  '''

  # url
  url = "https://www.uniprot.org/uploadlists/"
  
  # convert input id list to str
  ids_str = list2str(in_list = list2convert, sep = " ")
  
  # specify params 
  dic_params = {
    'from': convert_from,
    'to': convert_to, 
    'format': 'tab',
    'query': ids_str
  }
  
  # query and return
  data = urllib.parse.urlencode(dic_params)
  data = data.encode('utf-8')
  req = urllib.request.Request(url, data)
  with urllib.request.urlopen(req) as f: # query each id
    response = f.read()
  table = response.decode('utf-8') # as str
  table = pd.read_csv(StringIO(table), sep ="\t") # as pandas df
  return(table)
#--------------------------------------------------------------------------------------------------------------
