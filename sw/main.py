import sys

SIZE = 1024

with open("readmemfmt.hex", "r") as f:
  lst = f.readlines()
  bytelst = []
  i = 0
  for l in lst:
    l = l.strip()
    bytelst.append(l.split(" ")[1])
    if len(bytelst) == 4:
      print(''.join(bytelst[::-1]))
      bytelst = []
      i += 1
  
  for _ in range(i, SIZE):
    print('00000000')
print(i, file=sys.stderr)
      
