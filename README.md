## Download Tumblr Images
###### Ravi S. Rāmphal // 2013.04.07

I originally wrote this project in Python for Windows. It was clunky and hacky and relied on wget. I have re-written it in Ruby here.

**Python:**

```python
# =========== LIBRARIES ===========

import re
import os
import subprocess

# =========== CUSTOMIZE ===========

urlsfile = "url.txt" # a text file with each tumblr image link on its own line
wgetfile = "\"C:\\Users\\Ravi\\Documents\\School Work\\Resources\\Tools\\wget.exe\"" #wget location

# =========== CONSTANTS ===========

img_sizes = ["1280","500","400","250"]
tumblr_img_pattern = "(.*)_(.*)\.(.*)"

# =========== FUNCTIONS ===========

def dl_tumblr_img(url):
  
  url = re.search(tumblr_img_pattern, url)
  
  urlstem = url.group(1)
  urlext = url.group(3)
  
  for size in img_sizes:
    cmd = subprocess.Popen(wgetfile + " " + urlstem + "_" + size + "." + urlext, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    stop = True
    for line in cmd.stdout:
      if "403" in line.decode("utf-8"):
        stop = False
    if stop:
      return
      
# =========== PROGRAM ===========

file = open(urlsfile, 'r')
urls = file.readlines()
file.close()

counter = 1;
num_urls = str(len(urls))

for url in urls:
  print(str(counter) + " of " + num_urls + ": " + url)
  counter += 1
  dl_tumblr_img(url)
```
