with open("readmemfmt.hex", "r") as f:
  lst = f.readlines()
  bytelst = []
  for l in lst:
    l = l.strip()
    bytelst.append(l.split(" ")[1])
    if len(bytelst) == 4:
      print(''.join(bytelst[::-1]))
      bytelst = []
      
